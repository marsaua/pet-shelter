class VolunteersController < ApplicationController
  def index
    @volunteers = current_user.volunteers.order(:date)
    @volunteer  = Volunteer.new

    load_google_calendar_data
  end

  def create
    @volunteer = current_user.volunteers.new(volunteer_params)

    return handle_successful_creation if @volunteer.save

    handle_failed_creation
  end

  def create_event
    unless current_user.google_connected?
      return redirect_to volunteers_path, alert: "Google Calendar is not connected"
    end

    create_google_calendar_event(
      date: params[:date],
      duty: params[:duty]
    )

    redirect_to volunteers_path, notice: "Event created and added to Google Calendar!"
  rescue => e
    log_google_error("create_event", e)
    redirect_to volunteers_path, alert: "Error creating event: #{e.message}"
  end

  private

  def volunteer_params
    params.require(:volunteer).permit(:date, :duty)
  end

  def load_google_calendar_data
    @google_connected = current_user.google_connected?
    @google_events = []

    return unless @google_connected

    google = current_user.google_identity
    service = GoogleCalendarService.new(google)
    @google_events = service.list_events
  rescue => e
    log_google_error("index", e)
    @google_connected = false
    @google_events = []
  end

  def sync_volunteer_to_google_calendar
    return unless current_user.google_connected?

    google = current_user.google_identity
    calendar = GoogleCalendarService.new(google)

    calendar.create_event(
      summary: "Volunteer: #{@volunteer.duty.to_s.titleize}",
      start_time: @volunteer.date.to_datetime.change(hour: 10),
      end_time: @volunteer.date.to_datetime.change(hour: 12),
      description: "Scheduled via Pet Shelter"
    )

    true
  rescue => e
    Rails.logger.error "Failed to sync to Google Calendar: #{e.message}"
    false
  end

  def create_google_calendar_event(date:, duty:)
    google = current_user.google_identity
    calendar = GoogleCalendarService.new(google)

    calendar.create_event(
      summary: "Volunteer: #{duty.to_s.titleize}",
      start_time: Time.zone.parse(date).change(hour: 10),
      end_time: Time.zone.parse(date).change(hour: 12),
      description: "Pet Shelter volunteer duty"
    )
  end

  def handle_successful_creation
    current_user.google_connected?
      if sync_volunteer_to_google_calendar
        return redirect_to volunteers_path, notice: "Event created and added to Google Calendar!"
      end

    redirect_to volunteers_path, notice: "Event created! (Google Calendar sync failed - please try adding manually)"

  rescue => e
    redirect_to volunteers_path, alert: e || "Something went wrong"
  end

  def handle_failed_creation
    @volunteers = current_user.volunteers.order(:date)
    @google_events = []
    @google_connected = false
    render :index, status: :unprocessable_entity
  end


  def log_google_error(method_name, error)
    Rails.logger.warn "[GCAL##{method_name}] #{error.class}: #{error.message}"
    Rails.logger.debug error.backtrace&.first(5)&.join("\n") if Rails.env.development?
  end
end
