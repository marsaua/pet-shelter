class ChangeAgeToDateOfBirthInUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :date_of_birth, :date

    User.update_all(date_of_birth: 18.years.ago.to_date)

    change_column_null :users, :date_of_birth, false

    remove_column :users, :age if column_exists?(:users, :age)
  end

  def down
    remove_column :users, :date_of_birth
  end
end
