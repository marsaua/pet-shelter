class AdoptAccessWorker
    include Sidekiq::Worker

    def perform(user_id)
        user = User.find(user_id)
        AdoptAccessMailer.adopt_access(user).deliver_now
    end
end
