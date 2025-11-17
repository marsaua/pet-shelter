class ContactUsController < ApplicationController
    def create
        @contact_us = ContactUs.new(contact_us_params)
        if @contact_us.valid?
          ContactUsMailer.with(contact: @contact_us.attributes.symbolize_keys)
                         .contact_us
                         .deliver_later
          redirect_to contact_path, notice: I18n.t("contact_us.success_create")
        else
          flash.now[:alert] = I18n.t("contact_us.failed_create")
          render "pages/contact", status: :unprocessable_entity
        end
        @contact_us.save
      end

    private

    def contact_us_params
      params.require(:contact_us).permit(:first_name, :last_name, :email, :subject, :message)
    end
end
