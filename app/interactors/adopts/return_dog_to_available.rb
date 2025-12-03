module Adopts
    class ReturnDogToAvailable < BaseInteractor
      delegate :dog, :params, to: :context
        def call
            dog.update!(status: "available",
                        user_id: nil,
                        date_of_adopt: nil)

            context.dog = dog
        rescue ActiveRecord::RecordInvalid => e
            context.errors = e.record.errors.full_messages.join(", ")
            context.fail!
        rescue StandardError => e
            context.errors = e.message || I18n.t("failed_return", thing: "Dog")
            context.fail!
        end
    end
end
