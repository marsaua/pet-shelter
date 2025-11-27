class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :adopts, [:dog_id, :user_id], name: 'index_adopts_on_dog_and_user', if_not_exists: true
    add_index :adopts, :created_at, if_not_exists: true
    add_index :dogs, :status, if_not_exists: true
    add_index :volunteers, :date, if_not_exists: true
    add_index :comments, :user_id, if_not_exists: true
    add_index :volunteers, [:user_id, :date], if_not_exists: true
  end
end
