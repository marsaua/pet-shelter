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
        ChangeStatusDog.call(dog: @dog)

        @dog.diagnosis = {
            disease_name: params[:dog][:disease_name],
            medicine_name: params[:dog][:medicine_name],
            additional_info: params[:dog][:additional_info]
        }

        @dog.save!
        redirect_to @dog, notice: t("success_create", thing: "Dog"), status: :see_other
    rescue StandardError => e
        redirect_to dogs_path, alert: e || t("failed_create", thing: "Dog")
    end

    def show
        @adopts = policy_scope(Adopt).with_assotiations
    end

    def edit; end

    def update
        @dog.update!(dog_params)
        if @dog.saved_change_to_health_status?
            ChangeStatusDog.call(dog: @dog)
            @dog.save!
        end
        redirect_to @dog, notice: t("success_update", thing: "Dog"), status: :see_other
    rescue StandardError => e
        redirect_to dog_path(@dog), alert: e || t("failed_update", thing: "Dog")
    end

    def adopt_dog
        if @dog.status == "available"
            book_adoption
            return deliver_emails
        end
        return_dog_to_available

    rescue StandardError => e
        flash.now[:alert] = e || t("adopt.failed.return")
        render :show, status: :unprocessable_entity
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

    def return_dog_to_available
        @dog.update!(params.require(:dog).permit(:status).merge(date_of_adopt: nil))
        flash[:notice] = t("adopt.success.return")
        redirect_to dog_path(@dog), notice: t("adopt.success.return"), status: :see_other
    rescue StandardError => e
        redirect_to dog_path(@dog), alert: e || t("failed_return", thing: "Dog")
    end

    def book_adoption
        @adopt = Adopt.find(params[:adopt_id])
        @dog.update!(params.require(:dog).permit(:status).merge(user_id: @adopt.user.id, date_of_adopt: Date.today))
        redirect_to dog_path(@dog), notice: t("adopt.success.adopt"), status: :see_other
    rescue StandardError => e
        redirect_to dog_path(@dog), alert: e || t("failed_adopt", thing: "Dog")
    end

    def setup_comments_and_adopts
        @comments = @dog.comments.includes(:user).order(created_at: :desc)
        @comment = @dog.comments.build
    end

    def deliver_emails
        AdoptAccessWorker.perform_async(@adopt.user.id)

        @adopts = Adopt.where.not(id: params[:adopt_id])
        @adopts.each do |adopt|
            AdoptRejectWorker.perform_async(adopt.user.id)
        end
    end
end
