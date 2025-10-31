
class VolunteersController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @volunteers = current_user.volunteers.order(:date)
      @volunteer = Volunteer.new
      calendar = GoogleCalendarService.new(current_user)
      @google_events = calendar.list_events rescue []
    end
  
    def create
      @volunteer = current_user.volunteers.new(volunteer_params)
      if @volunteer.save
        # Додаємо в Google Calendar
        calendar = GoogleCalendarService.new(current_user)
        calendar.create_event(
          summary: "Волонтерство: #{@volunteer.role}",
          start_time: @volunteer.date.to_datetime.change(hour: 10),
          end_time: @volunteer.date.to_datetime.change(hour: 12)
        )
        redirect_to volunteers_path, notice: "Подію створено і додано в Google Calendar!"
      else
        @volunteers = current_user.volunteers.order(:date)
        render :index, status: :unprocessable_entity
      end
    end
    def create_event
        # беремо параметри з кнопки
        date = params[:date]
        role = params[:role]
      
        # створюємо подію в календарі
        calendar = GoogleCalendarService.new(current_user)
        calendar.create_event(
          summary: "Волонтерство: #{role}",
          start_time: DateTime.parse(date).change(hour: 10),
          end_time: DateTime.parse(date).change(hour: 12)
        )
      
        redirect_to volunteers_path, notice: "Подію додано до Google Calendar!"
      rescue => e
        redirect_to volunteers_path, alert: "Помилка при створенні події: #{e.message}"
      end
  
    private
  
    def volunteer_params
      params.require(:volunteer).permit(:date, :role)
    end
  end
  