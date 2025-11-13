class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  enum :role, { user: 0, manager: 1, admin: 2, guest: 3 }, default: :user

  has_many :volunteers, dependent: :destroy
  has_many :adopts, dependent: :destroy
  has_many :dogs, dependent: :nullify
  has_many :comments, dependent: :nullify

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
