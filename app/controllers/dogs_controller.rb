class DogsController < ApplicationController
    skip_before_action :authenticate_user!, only: %i[index show]

    before_action :authorize_dog, only: %i[new create]
    before_action :set_dog, only: %i[show edit update destroy adopt_dog]

    def index
        @dogs = Dog.recent_with_avatar(params[:page])
    end

    def new
        @dog = Dog.new
    end

    def create
        @dog = Dog.create!(dog_params)
        redirect_to @dog, notice: t("success_create", thing: "Dog"), status: :see_other
    rescue StandardError => e
        redirect_to dogs_path, alert: e || t("failed_create", thing: "Dog")
    end

    def show
        @adopts = policy_scope(Adopt).with_assotiations
        @comments = @dog.comments.includes(:user).order(created_at: :desc)
        @comment = @dog.comments.build
    end

    def edit; end

    def update
        @dog.update!(dog_params)
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
        params.require(:dog).permit(:name, :sex, :age_month, :size, :breed, :status, :avatar)
    end

    def return_dog_to_available
        @dog.update!(params.require(:dog).permit(:status))
        flash[:notice] = t("adopt.success.return")
        redirect_to dog_path(@dog), notice: t("adopt.success.return"), status: :see_other
    rescue StandardError => e
        redirect_to dog_path(@dog), alert: e || t("failed_return", thing: "Dog")
    end

    def book_adoption
        @adopt = Adopt.find(params[:adopt_id])
        @dog.update!(params.require(:dog).permit(:status).merge(user_id: @adopt.user.id))
        redirect_to dog_path(@dog), notice: t("adopt.success.adopt"), status: :see_other
    rescue StandardError => e
        redirect_to dog_path(@dog), alert: e || t("failed_adopt", thing: "Dog")
    end

    def deliver_emails
        AdoptAccessMailer.with(user: @adopt.user).adopt_access.deliver_later

        @adopts = Adopt.where.not(id: params[:adopt_id])
        @adopts.each do |adopt|
            AdoptRejectMailer.with(user: adopt.user).adopt_reject.deliver_later
        end
    end
end
