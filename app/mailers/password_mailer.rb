class PasswordMailer < ApplicationMailer
    def reset_password(user)
        @user = user
        mail(to: @user.email, subject: "Password Reset")
    end
end
