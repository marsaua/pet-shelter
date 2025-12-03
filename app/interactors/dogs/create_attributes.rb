module Dogs
  class CreateAttributes < BaseInteractor
    delegate :dog, :params, to: :context

    def call
      dog.diagnosis = {
              disease_name: params[:disease_name],
              medicine_name: params[:medicine_name],
              additional_info: params[:additional_info]
          }

      dog.save!
      context.dog = dog
    rescue ActiveRecord::RecordInvalid => e
      context.errors = e.record.errors.full_messages.join(", ")
      context.fail!
    end
  end
end
