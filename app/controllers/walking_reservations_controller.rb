class WalkingReservationsController < ApplicationController
  before_action :set_dog, only: %i[new create]
  before_action :check_dogs_available, only: :new
  before_action :initialize_session, only: %i[new create]
  before_action :validate_step, only: :new

  before_action :set_walking_reservation, only: %i[show destroy]

  VALID_STEPS = [1, 2, 3].freeze

  def index
    @walking_reservations = current_user.walking_reservations.includes(:dog).order(reservation_date: :desc)
  end

  def new
    @walking_reservation = @dog.walking_reservations.build
    @walking_reservation.assign_attributes(session[:reservation_data]) if session[:reservation_data].present?

    if params[:back].present?
      @step = [@step - 1, 1].max
      render :new
      return
    end

    case @step
    when 1
      if params[:reservation_date].present? && params[:time_slot].present?
        session[:reservation_data] ||= {}
        session[:reservation_data][:reservation_date] = params[:reservation_date]
        session[:reservation_data][:time_slot] = params[:time_slot]
        redirect_to new_dog_walking_reservation_path(@dog, step: 2)
        return
      end

    when 2
      if params[:walking_reservation].present? && params[:commit].present?
        session[:reservation_data] ||= {}
        session[:reservation_data].merge!(
          walking_reservation_params.slice(:responsible_name, :responsible_email, :responsible_phone)
        )
        redirect_to new_dog_walking_reservation_path(@dog, step: 3)
        return
      end

    when 3
    end

    render :new
  end

  def create
    reservation_data = (session[:reservation_data] || {}).merge(
      walking_reservation_params.slice(:rules_accepted)
    )

    @walking_reservation = @dog.walking_reservations.build(reservation_data)
    @walking_reservation.user = current_user

    if @walking_reservation.save
      session.delete(:reservation_data)
      redirect_to walking_reservations_path, notice: "Reservation created successfully"
    else
      @step = 3
      @walking_reservation.assign_attributes(session[:reservation_data]) if session[:reservation_data].present?
      flash.now[:alert] = @walking_reservation.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def destroy
    @walking_reservation.destroy
    redirect_to walking_reservations_path, notice: "Reservation deleted successfully"
  end

  private

  def validate_step
    @step = params[:step].to_i
    @step = 1 if @step.zero? || !VALID_STEPS.include?(@step)
  end

  def initialize_session
    session[:reservation_data] ||= {}
  end

  def set_dog
    @dog = Dog.find(params[:dog_id])
  end

  def set_walking_reservation
    @walking_reservation = WalkingReservation.find(params[:id])
  end

  def check_dogs_available
    if @dog.status == "unavailable"
      redirect_to dog_path(@dog), alert: "This dog is not available for walks"
    end
  end

  def walking_reservation_params
    params.require(:walking_reservation).permit(
      :reservation_date,
      :time_slot,
      :responsible_name,
      :responsible_email,
      :responsible_phone,
      :rules_accepted
    )
  end
end
