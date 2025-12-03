module Adopts
  class BookAdoption < BaseInteractor
    delegate :dog, :params, to: :context

    def call
        adopt = Adopt.find(params[:adopt_id])
        dog.update!(params.require(:dog).permit(:status).merge(user_id: adopt.user.id, date_of_adopt: Date.today))

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
