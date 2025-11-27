class PasswordWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    PasswordMailer.reset_password(user).deliver_now
  end
end
