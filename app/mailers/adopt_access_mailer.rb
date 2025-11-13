class AdoptAccessMailer < ApplicationMailer
    default from: email_address_with_name("notification@example.com", "Pet shelter")

    def adopt_access
        @user = params[:user]
        mail to: @user.email, subject: "Adoption request accepted"
      end
end
