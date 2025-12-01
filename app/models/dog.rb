class Dog < ApplicationRecord
    has_one_attached :avatar
    has_many :comments, as: :commentable, dependent: :nullify
    has_many :adopts, dependent: :destroy
    belongs_to :user, optional: true

    validates :size,   inclusion: { in: %w[small medium large] }
    validates :sex,    inclusion: { in: %w[male female] }
    validates :name, presence: true
    validates :age_month, presence: true
    validates :breed, presence: true
    validates :diagnosis, presence: true, allow_blank: true

    enum :status, { available: 0, available_for_walk: 1, unavailable: 2, adopted: 3, archived: 4 }, default: :available

    enum :health_status, { healthy: 0, ill: 1, chronically_diseased: 2, under_treatment: 3 }, default: :healthy

    enum :agressivness, { mostly_calm: 0, calm: 1, mostly_agressive: 2, agressive: 3 }, default: :mostly_calm

    scope :with_assotiations, -> { includes(:dog, :user) }
    scope :recent_with_avatar, ->(page = 1) {
            Dog.includes(:avatar_attachment)
            .order(created_at: :desc)
            .page(page)
            .per(3)
    }

    def diagnosis_pairs
        diagnosis.presence || {}
    end
end
