class WalkingReservation < ApplicationRecord
  belongs_to :user
  belongs_to :dog

  enum :status, { pending: 0, accepted: 1, rejected: 2 }

  WEEKDAY_SLOT = {
    "07:00-11:00" => "07:00 AM - 11:00 AM",
    "18:00-20:00" => "6:00 PM - 8:00 PM"
  }.freeze

  WEEKEND_SLOT = {
    "09:00-13:00" => "9:00 AM - 1:00 PM",
    "17:00-19:00" => "5:00 PM - 7:00 PM"
  }.freeze

  validates :reservation_date, presence: true
  validates :responsible_phone, presence: true, phone: true
  validates :responsible_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :responsible_name, presence: true
  validates :rules_accepted, acceptance: true

  validate :reservation_date_cannot_be_in_past
  validate :user_can_only_reserve_same_dog_once_per_day
  validate :user_cannot_have_another_dog_in_same_slot
  validate :dog_must_be_available_for_walking


  def available_slots_for_date
    if weekend?
      WEEKEND_SLOT
    else
      WEEKDAY_SLOT
    end
  end

  def weekend?
    reservation_date.saturday? || reservation_date.sunday?
  end

  def available_slots_for(date, user, dog)
    user_reservation = where(user: user, reservation_date: date)

    slots.reject { |slot| user_reservation.exists?(time_slot: slot) || dog.reservations.exists?(time_slot: slot) }
  end




  private
  def reservation_date_cannot_be_in_past
    errors.add(:reservation_date, I18n.t("errors.reservation_date_in_past")) if reservation_date < Date.today
  end

  def user_can_only_reserve_same_dog_once_per_day
    existing = WalkingReservation.where(
      user: user,
      dog: dog,
      reservation_date: reservation_date,
    ).where.not(id: id)
    if existing.exists?
      errors.add(:reservation_date, "You can only reserve the same dog once per day")
    end
  end

  def user_cannot_have_another_dog_in_same_slot
    existing = WalkingReservation.where(
      user: user,
      reservation_date: reservation_date,
      time_slot: time_slot,
    ).where.not(id: id)
    if existing.exists?
      errors.add(:reservation_date, "You can only reserve one dog in the same slot")
    end
  end

  def dog_must_be_available_for_walking
    if dog.status != "available"
      errors.add(:dog, "Dog must be available for walking")
    end
  end
end
