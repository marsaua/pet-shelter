class DogsController < ApplicationController
    before_action :set_dog, only: [:show, :edit, :update, :destroy]

    def index
        @dogs = Dog.all
    end
    def new
        @dog = Dog.new
    end
    def create
        @dog = Dog.new(dog_params)
        if @dog.save
            redirect_to @dog, flash[:success] = "Dog was successfully created."
        else
            flash[:error] = "Dog was not created."
            render :new, status: :unprocessable_entity
        end
    end
    def show
    end
    def edit
    end
    def update
        if @dog.update(dog_params)
            redirect_to @dog, flash[:success] = "Dog was successfully updated."
        else
            render :edit
        end
    end
    def destroy
        @dog.destroy
        redirect_to dogs_path, flash[:success] = "Dog was successfully deleted."
    end

    private
    def set_dog
        @dog = Dog.find(params[:id])
    end
    def dog_params
        params.require(:dog).permit(:name, :sex, :age_month, :size, :breed, :status)
    end
end
