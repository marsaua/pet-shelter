class DogsController < ApplicationController
    include Pundit::Authorization
    rescue_from Pundit::NotAuthorizedError do
        redirect_to root_path, alert: "Not authorized"
      end

    before_action :set_dog, only: %i[show edit update destroy adopt_dog]

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
            redirect_to @dog, notice: "Dog was successfully created.", status: :see_other
        else
            flash.now[:alert] = "Dog was not created."
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
            redirect_to @dog, notice: "Dog was successfully updated.", status: :see_other
        else
            flash.now[:error] = "Dog was not updated."
    render :edit, status: :unprocessable_entity
        end
    end

    def adopt_dog
        if @dog.status == "available"

            book_adoption

            deliver_emails

        elsif @dog.status == "adopted"
            @dog.update(params.require(:dog).permit(:status))
            flash[:notice] = "Dog was successfully returned."
            redirect_to dog_path(@dog)
        end
    end

    def destroy
        authorize @dog
        @dog.destroy
        redirect_to dogs_path, notice: "Dog was successfully deleted."
    end


    private

    def set_dog
        @dog = Dog.find(params[:id])
    end

    def dog_params
        params.require(:dog).permit(:name, :sex, :age_month, :size, :breed, :status, :avatar)
    end

    def book_adoption
        @adopt = Adopt.find(params[:adopt_id])
        @dog.update(params.require(:dog).permit(:status).merge(user_id: @adopt.user.id))
        redirect_to dog_path(@dog), notice: "Dog was successfully adopted."
    end

    def deliver_emails
        AdoptAccessMailer.with(user: @adopt.user).adopt_access.deliver_later

        @adopts = Adopt.where.not(id: params[:adopt_id])
        @adopts.each do |adopt|
            AdoptRejectMailer.with(user: adopt.user).adopt_reject.deliver_later
        end
    end
end
