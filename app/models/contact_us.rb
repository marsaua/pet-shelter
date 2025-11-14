class ContactUs < ApplicationRecord
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :first_name, :string
    attribute :last_name,  :string
    attribute :email,      :string
    attribute :subject,    :string
    attribute :message,    :string

    validates :first_name, :email, :message, presence: true
end
