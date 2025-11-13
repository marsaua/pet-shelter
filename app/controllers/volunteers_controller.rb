
class VolunteersController < ApplicationController
    include Pundit::Authorization
    before_action :authenticate_user!

  
    def index
      @volunteers = current_user.volunteers.order(:date)
      @volunteer = Volunteer.new
      
      # Try to get Google Calendar events
      google = current_user.sso_identities.find_by(provider: "google_oauth2")
      @google_events = []
      @google_connected = google&.access_token.present?

      
      if @google_connected
          calendar = GoogleCalendarService.new(google)
          @google_events = calendar.list_events
      else
          @google_events = []
      end
    end
  
    def create
      @volunteer = current_user.volunteers.new(volunteer_params)
      if @volunteer.save
        # Try to add to Google Calendar if connected
        if current_user.google_access_token.present?
          begin
            calendar = GoogleCalendarService.new(current_user)
            calendar.create_event(
              summary: "Volunteer: #{@volunteer.role}",
              start_time: @volunteer.date.to_datetime.change(hour: 10),
              end_time: @volunteer.date.to_datetime.change(hour: 12)
            )
            redirect_to volunteers_path, notice: "Event created and added to Google Calendar!"
          rescue => e
            Rails.logger.error "Failed to create Google Calendar event: #{e.message}"
            redirect_to volunteers_path, notice: "Event created! (Google Calendar sync failed - please try adding manually)"
          end
        else
          redirect_to volunteers_path, notice: "Event created! Connect Google Calendar to sync automatically."
        end
      else
        @volunteers = current_user.volunteers.order(:date)
        @google_events = []
        @google_connected = false
        render :index, status: :unprocessable_entity
      end
    end
    def create_event
        date = params[:date]
        role = params[:role]
      
        calendar = GoogleCalendarService.new(current_user)
        calendar.create_event(
          summary: "Volunteer: #{role}",
          start_time: DateTime.parse(date).change(hour: 10),
          end_time: DateTime.parse(date).change(hour: 12)
        )
      
        redirect_to volunteers_path, notice: "Event created and added to Google Calendar!"
      rescue => e
        redirect_to volunteers_path, alert: "Error creating event: #{e.message}"
      end
  
    private
  
    def volunteer_params
      params.require(:volunteer).permit(:date, :role)
    end
  end
  