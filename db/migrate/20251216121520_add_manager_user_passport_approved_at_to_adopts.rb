class AddManagerUserPassportApprovedAtToAdopts < ActiveRecord::Migration[8.0]
  def change
    add_reference :adopts, :manager_user, foreign_key: { to_table: :users }, index: true
    add_column :adopts, :passport, :string, null: true
    add_column :adopts, :approved_at, :datetime
  end
end
