class Report < ApplicationRecord
    belongs_to :user

    validates :name, :email, :message, presence: true

    after_create :send_report

    private

    def send_report
        ReportWorker.perform_async(id)
    end
end
