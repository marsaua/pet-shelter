class ChangeDateOfBirthToNullableInUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_null(:users, :date_of_birth, true)
    change_column_null(:users, :phone, true)
  end
end
