class CreateDogs < ActiveRecord::Migration[8.0]
  def change
    create_table :dogs do |t|
      t.string :name
      t.string :sex
      t.integer :age_month
      t.string :size
      t.string :breed
      t.string :status

      t.timestamps
    end
  end
end
