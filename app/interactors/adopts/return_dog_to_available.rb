module Adopts
    class ReturnDogToAvailable < BaseInteractor
      delegate :dog, :adopt_id, :current_user, to: :context
        def call
            adopt = Adopt.find(adopt_id)
            dog.update!(status: "available",
                        user_id: nil,
                        date_of_adopt: nil,
                        status: "available"
                        )
            adopt.update!(manager_user_id: current_user.id, approved_at: Time.now)
            context.adopt = adopt
        rescue ActiveRecord::RecordInvalid => e
            context.errors = e.record.errors.full_messages.join(", ")
            context.fail!
        rescue StandardError => e
            context.errors = e.message || I18n.t("failed_return", thing: "Dog")
            context.fail!
        end
    end
end
