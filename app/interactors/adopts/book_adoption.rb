module Adopts
  class BookAdoption < BaseInteractor
    delegate :dog, :dog_attributes, :adopt_id, to: :context

    def call
        adopt = Adopt.find(adopt_id)
        dog.update!(dog_attributes.merge(
                  user_id: adopt.user.id,
                  date_of_adopt: Date.today
                ))

        context.adopt = adopt
    rescue ActiveRecord::RecordNotFound => e
      context.errors = "Adoption request not found"
      context.fail!
    rescue ActiveRecord::RecordInvalid => e
      context.errors = e.record.errors.full_messages.join(", ")
      context.fail!
    end
  end
end
