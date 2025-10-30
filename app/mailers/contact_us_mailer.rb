class ContactUsMailer < ApplicationMailer
    default to: email_address_with_name('marsaua001@gmail.com', 'Contact Us from Pet Shelter')

    def contact_us
        @contact = params[:contact] # {:first_name, :last_name, :email, :message}
        mail(subject: "Contact Us from Pet Shelter") do |format|
            format.html
            format.text
        end
    end
end
