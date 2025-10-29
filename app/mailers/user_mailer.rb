class UserMailer < ApplicationMailer
    default from: "notification@example.com"

    def welcome(user)
        @user = user
        mail to: @user.email, subject: "Welcome to Petshelter"
      end
end
