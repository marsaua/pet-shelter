class ContactUs < ApplicationRecord

    validates :first_name, :email, :message, presence: true
end
