class WeeklyNewsletterWorker
  include Sidekiq::Worker

  def perform
    User.find_each do |user|
      UserMailer.weekly_newsletter(user).deliver_later
    end
    Rails.logger.info "Weekly newsletter sent to all users at #{Time.current}"
  end
end
