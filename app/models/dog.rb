class Dog < ApplicationRecord
    enum(:sex, { unknown: 0, male: "male", female: "female" }, default: :unknown, prefix: true)
    enum(:size, { unknown: 0, small: 1, medium: 2, large: 3 }, default: :unknown, prefix: true)
    enum(:status, { unknown: 0, available: 1, adopted: 2 }, default: :unknown, prefix: true)

    validates :name, presence: true
    validates :age_month, presence: true
    validates :breed, presence: true

    def index
        @dogs = Dog.all
    end

    def show
        @dog = Dog.find(params[:id])
    end

    def new
        @dog = Dog.new
    end

    def create
        @dog = Dog.new(dog_params)
        if @dog.save
            redirect_to @dog
        else
            render :new
        end
    end

    def edit
        @dog = Dog.find(params[:id])
    end

    def update
        @dog = Dog.find(params[:id])
        if @dog.update(dog_params)
            redirect_to @dog
        else
            render :edit
        end
    end

    def destroy
        @dog = Dog.find(params[:id])
        @dog.destroy
        redirect_to dogs_path
    end

    private


    def dog_params
        params.require(:dog).permit(:name, :sex, :age_month, :size, :breed, :status)
    end

end
