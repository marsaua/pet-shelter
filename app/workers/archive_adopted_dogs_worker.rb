class ArchiveAdoptedDogsWorker
  include Sidekiq::Worker

  def perform
    dogs_to_archive = Dog.where(status: :adopted)
                         .where("date_of_adopt <= ?", 30.days.ago)

    count = dogs_to_archive.update_all(status: :archived)

    Rails.logger.info "Archived #{count} dogs"
  end
end
