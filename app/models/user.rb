class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[ google_oauth2 ]

  enum :role, { user: 0, manager: 1, admin: 2, guest: 3 }, default: :user

  has_many :volunteers, dependent: :destroy
  has_many :adopts, dependent: :destroy
  has_many :dogs, through: :adopts, dependent: :destroy

  has_many :sso_identities, dependent: :destroy

  def identity_for(provider)
    sso_identities.find_by(provider:)
  end

  def google_identity
    @google_identity ||= identity_for("google_oauth2")
  end

  def google_connected?
    google_identity&.google_connected? || false
  end

  def self.anonymous
    @default ||= find_or_create_by!(email: "anonymous@example.com") do |u|
      u.password = SecureRandom.base58(16)
      u.name     = "Anonymous"
      u.role     = :guest if u.respond_to?(:role=)
    end
  end
end
