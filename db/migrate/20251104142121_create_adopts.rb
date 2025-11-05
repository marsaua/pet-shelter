class CreateAdopts < ActiveRecord::Migration[8.0]
  def change
    create_table :adopts do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.boolean :has_another_pets
      t.string :other_pets_types
      t.string :other_pets_count
      t.string :other_pets_notes
      t.boolean :yard, null: false, default: false
      t.boolean :home, null: false, default: 0
      t.references :dog, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
