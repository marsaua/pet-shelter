class AdoptsController < ApplicationController
  before_action :set_dog
  before_action :set_adopt, only: %i[show edit update destroy]
  before_action :authorize_adopt, only: %i[show edit update destroy]

  def index
    @adopts = policy_scope(Adopt).includes(:user, :dog)
  end

  def new
    @adopt = @dog.adopts.build
  end

  def create
    @adopt = @dog.adopts.build(adopt_params.merge(user: current_user))
    @adopt.save!
    redirect_to dog_path(@dog), notice: t("success_create", thing: "Adopt")
  rescue StandardError => e
    redirect_to dog_path(@dog), alert: e || t("failed_create", thing: "Adopt")
  end

  def requests
    @adopts = policy_scope(Adopt)
                .where(dog_id: @dog.id)
                .includes(:user, :dog)
                .order(created_at: :desc)
  end

  def show; end

  def edit; end

  def update
    @adopt.update!(adopt_params)
    redirect_to dog_path(@dog), notice: t("success_update", thing: "Adopt")
  rescue StandardError => e
    redirect_to dog_path(@dog), alert: e || t("failed_update", thing: "Adopt")
  end

  def destroy
    @adopt.destroy!
    redirect_to dog_path(@dog), notice: t("success_destroy", thing: "Adopt")
  rescue StandardError => e
    redirect_to dog_path(@dog), alert: e || t("failed_destroy", thing: "Adopt")
  end

  private

  def set_dog
    @dog = Dog.find(params[:id])
  end

  def set_adopt
    @adopt = @dog.adopts.find(params[:id])
  end

  def authorize_adopt
    authorize @adopt
  end

  def adopt_params
    params.require(:adopt).permit(:name, :email, :phone, :has_another_pets, :other_pets_types, :other_pets_count, :other_pets_notes, :yard, :home)
  end
end
