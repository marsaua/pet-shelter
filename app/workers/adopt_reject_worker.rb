class AdoptRejectWorker
    include Sidekiq::Worker

    def perform(user_id)
        user = User.find(user_id)
        AdoptRejectMailer.adopt_reject(user).deliver_now
    end
end
