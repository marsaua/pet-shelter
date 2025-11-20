class ReportsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :set_current_user

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    @report.user = current_user

    if @report.valid?
      @report.save
      ReportMailer.with(report: @report.attributes.symbolize_keys)
                      .report
                      .deliver_later
      redirect_to root_path, notice: "Your message has been sent successfully!"
    else
      flash.now[:alert] = "Report form is invalid."
      render "reports/new", status: :unprocessable_entity
    end
  end

  private

  def report_params
    params.require(:report).permit(:name, :email, :message)
  end

  def set_current_user
    @current_user = current_user
  end
end
