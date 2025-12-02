class AddColumnsToDogs < ActiveRecord::Migration[8.0]
  def change
    add_column :dogs, :health_status, :integer, default: 0
    add_column :dogs, :diagnosis, :jsonb, default: {}, null: false

    add_index :dogs, :diagnosis, using: :gin
  end
end
