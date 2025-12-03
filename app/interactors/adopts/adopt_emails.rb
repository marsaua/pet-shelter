module Adopts
  class AdoptEmails < BaseInteractor
    delegate :dog, to: :context

    def call
      adopt = context.adopt
      AdoptAccessWorker.perform_async(adopt.user.id)

      rejected_adopts = Adopt.where.not(id: adopt.id)
      rejected_adopts.each do |rejected_adopt|
          AdoptRejectWorker.perform_async(rejected_adopt.user.id)
      end
    end
  end
end
