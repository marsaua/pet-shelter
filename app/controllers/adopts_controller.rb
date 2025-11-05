class AdoptsController < ApplicationController
  before_action :set_dog
  before_action :set_adopt, only: [:show, :edit, :update, :destroy]
  def index
    @adopts = policy_scope(Adopt.includes(:dog, :user))
  end
  def new
    @adopt = @dog.adopts.build
  end

  def create
    @adopt = @dog.adopts.build(adopt_params.merge(user: current_user))
    if @adopt.save
      redirect_to dog_path(@dog)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def requests
    @adopts = policy_scope(Adopt)
                .where(dog_id: @dog.id)
                .includes(:user, :dog)
                .order(created_at: :desc)
  end

  def show
    authorize @adopt
  end

  def edit
    authorize @adopt
  end

  def update
    authorize @adopt
    if @adopt.update(adopt_params)
      redirect_to dog_path(@dog)
    else
      render :edit
    end
  end

  def destroy
    @adopt.destroy
    authorize @adopt
    redirect_to dog_path(@dog)
  end

  private

  def set_dog
    @dog = Dog.find(params[:dog_id] || params[:id])
  end

  def set_adopt
    @adopt = @dog.adopts.find(params[:id])
  end

  def adopt_params
    params.require(:adopt).permit(:name, :email, :phone, :has_another_pets, :other_pets_types, :other_pets_count, :other_pets_notes, :yard, :home)
  end
end
