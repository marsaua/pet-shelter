class RenameContactUsToReport < ActiveRecord::Migration[8.0]
  def change
    rename_table :contact_us, :reports
    add_column :reports, :name, :string
    add_column :reports, :email, :string
    add_column :reports, :subject, :string
    add_column :reports, :message, :text

    add_reference :reports, :user, foreign_key: true
  end
end
