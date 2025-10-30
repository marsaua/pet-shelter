class UserMailer < ApplicationMailer
    default from: email_address_with_name("notification@example.com", "Pet shelter")

    def welcome
        @user = params[:user]
        mail to: @user.email, subject: "Welcome to Petshelter"
      end
end
