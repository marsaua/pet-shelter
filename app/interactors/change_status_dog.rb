class ChangeStatusDog
  include Interactor

  STATUS_MAPPING = {
    "healthy" => "available",
    "ill" => "available_for_walk",
    "chronically_diseased" => "available",
    "under_treatment" => "unavailable"
  }.freeze

  def call
    dog = context.dog
    new_status = STATUS_MAPPING.fetch(dog.health_status, "available")

    dog.status = new_status
  end
end
