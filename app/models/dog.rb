class Dog < ApplicationRecord
    
    has_many :comments, as: :commentable, dependent: :nullify
    has_many :adopts, dependent: :destroy
    belongs_to :user, optional: true
    has_one_attached :avatar

    enum :sex, { male: 0, female: 1 }, presence: true
    enum :status, { available: 0, adopted: 1 }, presence: true
    enum :size, { small: 0, medium: 1, large: 2 }, presence: true
    
    validates :name, presence: true
    validates :age_month, presence: true
    validates :breed, presence: true
end
