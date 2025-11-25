class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :adopts, [:dog_id, :user_id], name: 'index_adopts_on_dog_and_user'
    add_index :adopts, :created_at
    add_index :dogs, :status
    add_index :volunteers, :date
    add_index :comments, :user_id
    add_index :volunteers, [:user_id, :date]
  end
end
