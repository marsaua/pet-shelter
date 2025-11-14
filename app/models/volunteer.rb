class Volunteer < ApplicationRecord

  belongs_to :user
  has_many :dogs, dependent: :destroy

  enum :duty, { cleaner: 0, walker: 1, feeder: 2 }, presence: true
  validate :date_cannot_be_in_the_past


    private

    def date_cannot_be_in_the_past
      return if date.blank?

      parsed_date = date.is_a?(String) ? Date.parse(date) : date
      errors.add(:date, "can't be in the past") if parsed_date < Date.today
    rescue ArgumentError
      errors.add(:date, "is invalid")
    end
end
