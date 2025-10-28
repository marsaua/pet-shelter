class Dog < ApplicationRecord
    validates :size,   inclusion: { in: %w[small medium large] }
    validates :sex,    inclusion: { in: %w[male female] }
    validates :status, inclusion: { in: %w[available adopted] }
    validates :name, presence: true
    validates :age_month, presence: true
    validates :breed, presence: true
    has_one_attached :avatar
    has_many :comments, as: :commentable
end
