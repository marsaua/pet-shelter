module Adopts
  class AdoptDogOrganizer < BaseOrganizer
    organize Adopts::BookAdoption, Adopts::AdoptEmails, Adopts::AboutAdoptationForManagerEmail
  end
end
