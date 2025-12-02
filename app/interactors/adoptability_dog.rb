class AdoptabilityDog
  include Interactor

  def call
    dog = context.dog

    unless dog.available? || dog.adopted? || dog.archived?
      context.fail!(error: "Dog is not available for adoption")
    end
  end
end
