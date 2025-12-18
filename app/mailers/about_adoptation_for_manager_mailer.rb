class AboutAdoptationForManagerMailer < ApplicationMailer
  default from: email_address_with_name("notification@example.com", "Pet shelter")

  def about_adoptation_for_manager(dog, adopt)
    @dog = dog
    @adopt = adopt
    @managers = User.where.not(role: "user")
    mail to: @managers.pluck(:email), subject: "New adoption request for #{@dog.name}"
  end
end
