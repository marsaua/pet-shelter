class UserMailer < ApplicationMailer
    default from: "notification@example.com"

    def welcome
        @user = params[:user]
        mail to: @user.email, subject: "Welcome to Petshelter"
      end
end
