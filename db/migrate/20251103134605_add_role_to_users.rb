class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :role, :integer, default: 0, null: true
    execute "UPDATE users SET role = 0 WHERE role IS NULL" # backfill -> :user
    change_column_null :users, :role, false
  end

  def down
    remove_column :users, :role
  end
end
