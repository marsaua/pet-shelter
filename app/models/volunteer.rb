class Volunteer < ApplicationRecord
    validates :duty, presence: true, inclusion: { in: %w[ walker feeder cleaner ] }
    validate :date_cannot_be_in_the_past

    belongs_to :user
    has_many :dogs, dependent: :destroy

    private

    def date_cannot_be_in_the_past
      return if date.blank?

      errors.add(:date, "can't be in the past") if date < Date.today
    end
end
