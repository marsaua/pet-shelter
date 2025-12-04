module Adopts
  class AdoptDogOrganizer < BaseOrganizer
    organize Adopts::BookAdoption, Adopts::AdoptEmails
  end
end
