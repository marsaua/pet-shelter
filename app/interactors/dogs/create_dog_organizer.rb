module Dogs
  class CreateDogOrganizer < BaseOrganizer
    organize Dogs::CreateAttributes, Dogs::ChangeStatus
  end
end
