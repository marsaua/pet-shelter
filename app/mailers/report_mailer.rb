class ReportMailer < ApplicationMailer
    default to: email_address_with_name("marsaua001@gmail.com", "Report from Pet Shelter")
    default from: email_address_with_name("no-reply@mg.abrakadabramarsa.space", "Report from Pet Shelter")

    def report(report)
        @report = report # {:first_name, :last_name, :email, :message}
        mail(subject: "Report from Pet Shelter") do |format|
            format.html
            format.text
        end
    end
end
