class PasswordMailer < ApplicationMailer
    def reset_password
        @user = params[:user]
        mail(to: @user.email, subject: "Password Reset")
    end
end
