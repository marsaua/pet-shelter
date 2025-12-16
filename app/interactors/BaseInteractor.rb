class BaseInteractor
  include Interactor

  def fail!(message)
    context.fail!(error: message)
  end
end
