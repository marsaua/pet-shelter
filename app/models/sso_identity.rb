class SsoIdentity < ApplicationRecord
    belongs_to :user
    validates :provider, :uid, presence: true
    validates :uid, uniqueness: { scope: :provider }

    def google_credentials
        return unless provider == "google_oauth2" && access_token.present?
    
        require "googleauth"
    
        creds = Google::Auth::UserRefreshCredentials.new(
          client_id:     ENV["GOOGLE_CLIENT_ID"],
          client_secret: ENV["GOOGLE_CLIENT_SECRET"],
          refresh_token: refresh_token,
          access_token:  access_token
        )
    
        if token_expires_at && token_expires_at < Time.current
          creds.refresh!
          update!(
            access_token:     creds.access_token,
            token_expires_at: Time.current + creds.expires_in.seconds
          )
        end
    
        creds
      end
  
    def self.upsert_from_omniauth(auth)
      provider = auth.provider
      uid      = auth.uid
      email    = auth.info&.email
  
      identity = find_or_initialize_by(provider:, uid:)
  
      user = identity.user || User.find_or_initialize_by(email:)
      user.name  ||= auth.info&.name
      user.image ||= auth.info&.image
      user.password ||= Devise.friendly_token[0, 20]
      user.save!
  
      creds = auth.credentials
      identity.user = user
      identity.assign_attributes(
        access_token:     creds&.token,
        refresh_token:    creds&.refresh_token.presence || identity.refresh_token,
        token_expires_at: creds&.expires_at && Time.at(creds.expires_at),
        name:  auth.info&.name,
        image: auth.info&.image,
        data:  auth.extra&.to_h || {}
      )
      identity.save!
  
      user
    end
  end
  