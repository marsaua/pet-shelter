class ContactUsController < ApplicationController
    def create
        @contact_us = ContactUs.new(contact_us_params)
        if @contact_us.valid?
          ContactUsMailer.with(contact: @contact_us.attributes.symbolize_keys)
                         .contact_us
                         .deliver_later
          redirect_to contact_path, notice: "Your message has been sent successfully!"
        else
          flash.now[:alert] = "Contact Us form is invalid."
          render "pages/contact", status: :unprocessable_entity
        end
      end
  
    private
  
    def contact_us_params
      params.require(:contact_us).permit(:first_name, :last_name, :email, :subject, :message)
    end
  end