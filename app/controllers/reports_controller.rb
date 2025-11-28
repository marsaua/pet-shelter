class ReportsController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :set_current_user

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    @report.user = current_user

    @report.save!
    redirect_to root_path, notice: t("contact_us.success_create")
  rescue StandardError => e
    flash.now[:alert] = e || t("contact_us.failed_create")
    render "reports/new", status: :unprocessable_entity
  end

  private

  def report_params
    params.require(:report).permit(:name, :email, :message)
  end

  def set_current_user
    @current_user = current_user
  end
end
