class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 github]

  enum :role, { user: 0, manager: 1, admin: 2, guest: 3 }, default: :user

  has_many :volunteers, dependent: :destroy
  has_many :adopts, dependent: :destroy
  has_many :dogs, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :reports, dependent: :nullify
  has_many :sso_identities, dependent: :destroy
  has_many :walking_reservations, dependent: :destroy

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :phone, phone: true, allow_blank: true
  validates :date_of_birth, date: {
    before: Proc.new { Time.now - 18.years },
    message: "You must be at least 18 years old"
  }, if: -> { date_of_birth.present? }
  validates :name, presence: true

  after_create :send_welcome_email


  def identity_for(provider)
    sso_identities.find_by(provider:)
  end

  def google_identity
    @google_identity ||= identity_for("google_oauth2")
  end

  def google_connected?
    google_identity&.google_connected? || false
  end

  def send_welcome_email
    WelcomeWorker.perform_async(id)
  end
end
