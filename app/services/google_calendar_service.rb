require 'google/apis/calendar_v3'

class GoogleCalendarService
  def initialize(user)
    @user = user
    @service = Google::Apis::CalendarV3::CalendarService.new
    
    credentials = user.google_credentials
    if credentials.nil?
      raise "User #{user.id} does not have valid Google credentials"
    end
    
    @service.authorization = credentials
  end

  def list_events
    return [] unless @service.authorization
    
    begin
      result = @service.list_events(
        'primary',
        max_results: 10,
        single_events: true,
        order_by: 'startTime',
        time_min: Time.now.iso8601
      )
      result.items || []
    rescue Google::Apis::AuthorizationError => e
      Rails.logger.error "Google Calendar authorization error: #{e.message}"
      []
    rescue => e
      Rails.logger.error "Google Calendar API error: #{e.message}"
      []
    end
  end

  def create_event(summary:, start_time:, end_time:)
    return nil unless @service.authorization
    
    begin
      event = Google::Apis::CalendarV3::Event.new(
        summary: summary,
        description: "Volunteer session scheduled through our platform",
        start: { 
          date_time: start_time.iso8601, 
          time_zone: 'Europe/Kiev' 
        },
        end: { 
          date_time: end_time.iso8601, 
          time_zone: 'Europe/Kiev' 
        }
      )
      
      result = @service.insert_event('primary', event)
      Rails.logger.info "Created Google Calendar event: #{result.id}"
      result
    rescue Google::Apis::AuthorizationError => e
      Rails.logger.error "Google Calendar authorization error: #{e.message}"
      raise "Authorization failed. Please reconnect your Google account."
    rescue => e
      Rails.logger.error "Google Calendar API error: #{e.message}"
      raise "Failed to create calendar event: #{e.message}"
    end
  end
  
  def connected?
    @service.authorization.present? && @user.google_access_token.present?
  end
end
