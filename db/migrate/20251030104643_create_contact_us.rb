class CreateContactUs < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_us do |t|
      t.timestamps
    end
  end
end
