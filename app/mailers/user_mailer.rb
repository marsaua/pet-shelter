class UserMailer < ApplicationMailer
  default from: email_address_with_name("notification@example.com", "Pet shelter")

  def welcome(user)
    @user = user
    mail to: @user.email, subject: "Welcome to Petshelter"
  end

  def weekly_newsletter(user)
    @user = user
    mail to: @user.email, subject: "Weekly newsletter"
  end
end
