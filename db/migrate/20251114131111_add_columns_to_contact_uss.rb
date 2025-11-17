class AddColumnsToContactUss < ActiveRecord::Migration[8.0]
  def change
    add_column :contact_us, :first_name, :string
    add_column :contact_us, :last_name, :string
    add_column :contact_us, :email, :string
    add_column :contact_us, :subject, :string
    add_column :contact_us, :message, :string
  end
end
