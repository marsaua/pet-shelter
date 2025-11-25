class Dog < ApplicationRecord
    has_one_attached :avatar
    has_many :comments, as: :commentable, dependent: :nullify
    has_many :adopts, dependent: :destroy
    belongs_to :user, optional: true

    validates :size,   inclusion: { in: %w[small medium large] }
    validates :sex,    inclusion: { in: %w[male female] }
    validates :status, inclusion: { in: %w[available adopted] }
    validates :name, presence: true
    validates :age_month, presence: true
    validates :breed, presence: true

    scope :with_assotiations, -> { includes(:dog, :user) }
    scope :recent_with_avatar, ->(page = 1) {
            Dog.includes(:avatar_attachment)
            .order(created_at: :desc)
            .page(page)
            .per(3)
    }
end
