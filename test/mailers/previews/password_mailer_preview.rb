# Preview all emails at http://localhost:3000/rails/mailers/password_mailer
class PasswordMailerPreview < ActionMailer::Preview
    def reset_password
        PasswordMailer.reset_password(user: User.first)
    end
end
