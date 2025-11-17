class DogsController < ApplicationController
    include Pundit::Authorization
    rescue_from Pundit::NotAuthorizedError do
        redirect_to root_path, alert: I18n.t("pundit.unauthorized")
      end

    before_action :set_dog, only: %i[ show edit update destroy adopt_dog ]

    def index
        @dogs = Dog.all
        @dogs = @dogs.page(params[:page]).per(3)
    end
    def new
        @dog = Dog.new
        authorize @dog
    end
    def create
        @dog = Dog.new(dog_params)
        authorize @dog
        if @dog.save
            redirect_to @dog, notice: I18n.t("success_create", thing: "Dog"), status: :see_other
        else
            flash.now[:alert] = I18n.t("failed_create", thing: "Dog")
            render :new, status: :unprocessable_entity
        end
    end

    def show
        @dog = Dog.find(params[:id])

        @adopt = Adopt.new(dog: @dog, user: current_user)

        @comments = @dog.comments.order(created_at: :desc)
        @comment = @dog.comments.build
      end
    def edit
        authorize @dog
    end

    def update
        authorize @dog
        if @dog.update(dog_params)
            redirect_to @dog, notice: I18n.t("success_update", thing: "Dog"), status: :see_other
        else
            flash.now[:error] = I18n.t("failed_update", thing: "Dog")
    render :edit, status: :unprocessable_entity
        end
    end

    def adopt_dog
        if @dog.status == "available"
            @adopt = Adopt.find(params[:adopt_id])
             if @dog.update(params.require(:dog).permit(:status).merge(user_id: @adopt.user.id))
                flash[:notice] = I18n.t("adopt.success_adopt", thing: "Dog")
                AdoptAccessMailer.with(user: @adopt.user).adopt_access.deliver_later
                redirect_to dog_path(@dog)
            else
                flash.now[:alert] = I18n.t("adopt.failed_adopt", thing: "Dog")
                render :show, status: :unprocessable_entity
            end
            @adopts = Adopt.where.not(id: params[:adopt_id])
            @adopts.each do |adopt|
                AdoptRejectMailer.with(user: adopt.user).adopt_reject.deliver_later
            end
        elsif @dog.status == "adopted"
            if @dog.update(params.require(:dog).permit(:status))
                flash[:notice] = I18n.t("adopt.success_return", thing: "Dog")
                redirect_to dog_path(@dog)
            else
                flash.now[:alert] = I18n.t("adopt.failed_return", thing: "Dog")
                render :show, status: :unprocessable_entity
            end
        end
    end

    def destroy
        authorize @dog
        @dog.destroy
        redirect_to dogs_path, notice: I18n.t("success_destroy", thing: "Dog")
    end


    private
    def set_dog
        @dog = Dog.find(params[:id])
    end
    def dog_params
        params.require(:dog).permit(:name, :sex, :age_month, :size, :breed, :status, :avatar)
    end
end
