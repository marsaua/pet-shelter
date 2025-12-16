require "googleauth"

class SsoIdentity < ApplicationRecord
  AVAILABLE_PROVIDERS = %w[google_oauth2 github].freeze

  belongs_to :user
  validates :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def google_credentials
    return unless AVAILABLE_PROVIDERS.include?(provider) && access_token.present?

    if token_expires_at && token_expires_at < Time.current && refresh_token.blank?
      Rails.logger.warn "Google token expired and no refresh token available for SSO Identity #{id}"
      return nil
    end

    creds = Google::Auth::UserRefreshCredentials.new(
      client_id:     ENV["GOOGLE_CLIENT_ID"],
      client_secret: ENV["GOOGLE_CLIENT_SECRET"],
      refresh_token: refresh_token,
      access_token:  access_token
    )

    if token_expires_at && token_expires_at < Time.current && refresh_token.present?
      Rails.logger.info "Refreshing Google token for SSO Identity #{id}"
      creds.refresh!

      update!(
        access_token:     creds.access_token,
        token_expires_at: Time.current + creds.expires_in.seconds
      )
    end

    creds
  rescue => e
    Rails.logger.error "Failed to create Google credentials for SSO Identity #{id}: #{e.message}"
    nil
  end

  def self.upsert_from_omniauth(auth)
    provider = auth.provider
    uid      = auth.uid
    email    = auth.info&.email

    identity = find_or_initialize_by(provider:, uid:)

    user = identity.user || User.find_or_initialize_by(email:)

    user.name     ||= auth.info&.name || email&.split("@")&.first || "User"
    user.image    ||= auth.info&.image
    user.password ||= Devise.friendly_token[0, 20]

    if user.new_record?
      user.save(validate: false)
    else
      user.save! if user.changed?
    end

    case provider
    when "github"
      resolve_github_identity(identity:, auth:, user:)
    when "google_oauth2"
      resolve_google_identity(identity:, auth:, user:)
    else
      raise StandardError, "Unknown provider: #{provider}"
    end

    identity.save!

    user
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "SSO upsert failed (validation). provider=#{provider} uid=#{uid} email=#{email} user_id=#{user&.id} errors=#{e.record.errors.full_messages.to_sentence}"
    nil
  rescue => e
    Rails.logger.error "SSO upsert failed. provider=#{provider} uid=#{uid} email=#{email} user_id=#{user&.id} error=#{e.class}: #{e.message}"
    nil
  end

  def self.resolve_github_identity(identity:, auth:, user:)
    user.image ||= auth.info.image
    user.save(validate: false) if user.changed?

    identity.user = user
    identity.name = auth.info.name
    identity.image = auth.info.image
    identity.data = auth.extra.raw_info.to_h
  end

  def self.resolve_google_identity(identity:, auth:, user:)
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
  end

  def google_connected?
    return false unless AVAILABLE_PROVIDERS.include?(provider) && access_token.present?

    if token_expires_at && token_expires_at < Time.current && refresh_token.blank?
      return false
    end

    true
  end
end
