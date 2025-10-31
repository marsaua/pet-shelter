require 'google/apis/calendar_v3'

class GoogleCalendarService
  def initialize(user)
    @user = user
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.authorization = user.google_credentials
  end

  def list_events
    @service.list_events(
      'primary',
      max_results: 10,
      single_events: true,
      order_by: 'startTime',
      time_min: Time.now.iso8601
    ).items
  end

  def create_event(summary:, start_time:, end_time:)
    event = Google::Apis::CalendarV3::Event.new(
      summary: summary,
      start: { date_time: start_time.iso8601, time_zone: 'Europe/Kyiv' },
      end:   { date_time: end_time.iso8601, time_zone: 'Europe/Kyiv' }
    )
    @service.insert_event('primary', event)
  end
end
