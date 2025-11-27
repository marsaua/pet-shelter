class WelcomeWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.welcome(user).deliver_later
  end
end
