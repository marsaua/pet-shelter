class AdoptRejectMailer < ApplicationMailer
    default from: email_address_with_name("notification@example.com", "Pet shelter")

    def adopt_reject(user)
        @user = user
        mail to: @user.email, subject: "Adoption request rejected"
    end
end
