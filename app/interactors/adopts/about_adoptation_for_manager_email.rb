module Adopts
    class AboutAdoptationForManagerEmail < BaseInteractor
        delegate :dog, :adopt, to: :context

        def call
            AboutAdoptationForManagerMailer.about_adoptation_for_manager(dog, adopt).deliver_later
        end
    end
end
