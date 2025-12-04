module Dogs
  class ChangeStatus < BaseInteractor
    delegate :dog, to: :context

    STATUS_MAPPING = {
      "healthy" => "available",
      "ill" => "available_for_walk",
      "chronically_diseased" => "available",
      "under_treatment" => "unavailable"
    }.freeze

    def call
      new_status = STATUS_MAPPING.fetch(dog.health_status, "available")
      return if dog.status == new_status

      dog.status = new_status
      dog.save!
    rescue ActiveRecord::RecordInvalid => e
      context.errors = e.record.errors.full_messages.join(", ")
      context.fail!
    end
  end
end
