class CreateWalkingReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :walking_reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :dog, null: false, foreign_key: true
      t.date :reservation_date, null: false
      t.string :time_slot, null: false
      t.integer :status, default: 0, null: false
      t.string :responsible_name, null: false
      t.string :responsible_phone, null: false
      t.string :responsible_email, null: false
      t.boolean :rules_accepted, default: false, null: false

      t.timestamps
    end

    add_index :walking_reservations, [:user_id, :dog_id, :reservation_date], unique: true, name: 'index_walking_reservations_on_user_dog_date'
    add_index :walking_reservations, [:user_id, :time_slot, :reservation_date], name: 'index_walking_reservations_on_user_time_date'
  end
end
