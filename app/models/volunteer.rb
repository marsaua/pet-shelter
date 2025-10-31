class Volunteer < ApplicationRecord
    validates :role, presence: true, inclusion: { in: %w[ walker feeder cleaner ] }
    validate :date_cannot_be_in_the_past

    belongs_to :user
    has_many :dogs

    private

    def date_cannot_be_in_the_past
      return if date.blank?
    
      begin
        parsed_date = date.is_a?(String) ? Date.parse(date) : date
        errors.add(:date, "can't be in the past") if parsed_date < Date.today
      rescue ArgumentError
        errors.add(:date, "is invalid")
      end
    end
end
