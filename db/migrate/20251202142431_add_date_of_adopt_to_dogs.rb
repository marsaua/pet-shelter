class AddDateOfAdoptToDogs < ActiveRecord::Migration[8.0]
  def change
    add_column :dogs, :date_of_adopt, :datetime, null: true
  end
end
