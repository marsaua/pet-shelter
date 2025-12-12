class DogsController < ApplicationController
    skip_before_action :authenticate_user!, only: %i[index show]

    before_action :authorize_dog, only: %i[new create]
    before_action :set_dog, only: %i[show edit update destroy adopt_dog]
    before_action :setup_comments_and_adopts, only: %i[show]

    def index
        @dogs = Dog.recent_with_avatar(params[:page])
    end

    def new
        @dog = Dog.new
    end

    def create
        @dog = Dog.new(dog_params)
        result = Dogs::CreateDogOrganizer.call(dog: @dog, params: params[:dog])

        return redirect_to @dog, notice: t("success_create", thing: "Dog"), status: :see_other if result.success?

        flash.now[:alert] = result.error || t("failed_create", thing: "Dog")
        render :new, status: :unprocessable_entity
    end

    def show
        @adopts = policy_scope(Adopt).with_assotiations
    end

    def edit; end

    def update
        @dog.update!(dog_params)
        Dogs::ChangeStatus.call(dog: @dog)
        redirect_to @dog, notice: t("success_update", thing: "Dog"), status: :see_other
    rescue StandardError => e
        redirect_to dog_path(@dog), alert: e || t("failed_update", thing: "Dog")
    end

    def adopt_dog
        organizer = @dog.available? ? Adopts::AdoptDogOrganizer : Adopts::ReturnDogOrganizer

        result = organizer.call(
            dog: @dog,
            dog_attributes: params.require(:dog).permit(:status),
            adopt_id: params[:adopt_id]
        )

        if result.success?
            notice_key = @dog.available? ? "adopt.success.return" : "adopt.success.adopt"
            redirect_to dog_path(@dog), notice: t(notice_key), status: :see_other
        else
            flash.now[:alert] = result.errors || t("adopt.failed")
            render :show, status: :unprocessable_entity
        end
    end

    def destroy
        @dog.destroy
        redirect_to dogs_path, notice: t("success_destroy", thing: "Dog")
    rescue StandardError => e
        redirect_to dog_path(@dog), alert: e || t("failed_destroy", thing: "Dog")
    end


    private

    def set_dog
        @dog = Dog.find(params[:id])
    end

    def authorize_dog
        authorize @dog || Dog.new
    end

    def dog_params
        params.require(:dog).permit(:name, :sex, :age_month, :size, :breed, :status, :avatar, :diagnosis, :health_status)
    end

    def setup_comments_and_adopts
        @comments = @dog.comments.includes(:user).order(created_at: :desc)
        @comment = @dog.comments.build
    end
end
