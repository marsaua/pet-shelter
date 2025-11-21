class ReportsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]

  before_action :set_current_user, only: %i[new create]

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
      redirect_to root_path, notice: t("contact_us.success_create")
    else
      flash.now[:alert] = t("contact_us.failed_create")
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
