
class VolunteersController < ApplicationController
    include Pundit::Authorization
    before_action :authenticate_user!


    def index
      @volunteers = current_user.volunteers.order(:date)
      @volunteer  = Volunteer.new
    
      @google_connected = current_user.google_connected?
      @google_events = []
    
      if @google_connected
        begin
          google = current_user.google_identity
          service = GoogleCalendarService.new(google)
          @google_events = service.list_events
        rescue => e
          Rails.logger.warn "[GCAL#index] #{e.class}: #{e.message}"
          @google_connected = false
          @google_events = []
        end
      end
    end

    def create
      @volunteer = current_user.volunteers.new(volunteer_params)
      if @volunteer.save
        # Try to add to Google Calendar if connected
        if current_user.google_connected?
          begin
            google = current_user.google_identity
            calendar = GoogleCalendarService.new(google) 
            calendar.create_event(
              summary: "Volunteer: #{@volunteer.duty.to_s.titleize}",
              start_time: @volunteer.date.to_datetime.change(hour: 10),
              end_time: @volunteer.date.to_datetime.change(hour: 12),
              description: "Scheduled via Pet Shelter"
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
      raise "Google is not connected" unless current_user.google_connected?
      
      google = current_user.google_identity
    
      date = params[:date]
      duty = params[:duty]
    
      calendar = GoogleCalendarService.new(google)
      calendar.create_event(
        summary: "Volunteer: #{duty.to_s.titleize}",
        start_time: Time.zone.parse(date).change(hour: 10),
        end_time:   Time.zone.parse(date).change(hour: 12),
        description: "Pet Shelter volunteer duty"
      )
      redirect_to volunteers_path, notice: "Event created and added to Google Calendar!"
    rescue => e
      Rails.logger.error("[GCAL#create_event] #{e.class}: #{e.message}\n#{e.backtrace&.first(5)&.join("\n")}")
      redirect_to volunteers_path, alert: "Error creating event: #{e.message}"
    end

    private

    def volunteer_params
      params.require(:volunteer).permit(:date, :duty)
    end
end
