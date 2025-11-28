class ReportWorker
    include Sidekiq::Worker

    def perform(report_id)
      report = Report.find(report_id)
      ReportMailer.report(report).deliver_now
    end
end
