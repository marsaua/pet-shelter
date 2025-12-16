module Adopts
  class BookAdoption < BaseInteractor
    delegate :dog, :dog_attributes, :adopt_id, :current_user, to: :context

    def call
        adopt = Adopt.find(adopt_id)
        dog.update!(dog_attributes.merge(
                  user_id: adopt.user.id,
                  date_of_adopt: Date.today,
                  status: "adopted"
                ))
        adopt.update!( manager_user_id: current_user.id, approved_at: Time.now)

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
