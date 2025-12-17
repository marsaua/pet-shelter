class Adopt < ApplicationRecord
    belongs_to :dog
    belongs_to :user
    belongs_to :manager_user, class_name: "User", optional: true

    validates :name, presence: true
    validates :has_another_pets, inclusion: { in: [true, false] }
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :phone, phone: true

    scope :for_dog, ->(dog) { where(dog: dog) }
    scope :recent, -> { order(created_at: :desc) }
    scope :with_assotiations, -> { includes(:dog, :user) }
    scope :includes_dog, -> { includes([:dog]) }
end
