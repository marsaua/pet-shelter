class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[ google_oauth2 ]

  enum :role, { user: 0, manager: 1, admin: 2 }, default: :user

  has_many :volunteers
  has_many :adopts
  has_many :dogs, through: :adopts

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
end
