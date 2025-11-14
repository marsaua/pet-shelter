class Adopt < ApplicationRecord
    belongs_to :dog
    belongs_to :user
    validates :name, presence: true
    validates :has_another_pets, inclusion: { in: [ true, false ] }
    validates :email, presence: true
    validates :phone, presence: true
end
