class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :omniauthable, omniauth_providers: [:google_oauth2]
  
  enum :role, { user: 0, manager: 1, admin: 2 }, default: :user
  has_many :volunteers
  has_many :adopts
  def google_credentials
    return nil unless google_access_token.present?
    
    require 'googleauth'
    
    credentials = Google::Auth::UserRefreshCredentials.new(
      client_id: ENV["GOOGLE_CLIENT_ID"],
      client_secret: ENV["GOOGLE_CLIENT_SECRET"],
      refresh_token: google_refresh_token,
      access_token: google_access_token
    )
    
    # Refresh token if expired
    if google_token_expires_at && google_token_expires_at < Time.current
      credentials.refresh!
      update!(
        google_access_token: credentials.access_token,
        google_token_expires_at: Time.current + credentials.expires_in.seconds
      )
    end
    
    credentials
  end

  def self.from_google_omniauth(auth)
    user = find_by(email: auth.info.email)
    user ||= find_by(google_uid: auth.uid)
    user ||= new(email: auth.info.email)

    user.google_uid = auth.uid if user.respond_to?(:google_uid=)
    user.name       = auth.info.name  if auth.info&.name && user.respond_to?(:name=)
    user.image      = auth.info.image if auth.info&.image && user.respond_to?(:image=)

    creds = auth.credentials
    user.google_access_token     = creds.token
    user.google_refresh_token  ||= creds.refresh_token if creds.refresh_token.present?
    user.google_token_expires_at = Time.at(creds.expires_at) if creds.expires_at

    user.password ||= Devise.friendly_token[0, 20]
    user.save!
    user
  end
end
