class ChangeVolunteerDateToDate < ActiveRecord::Migration[8.0]
  def up
    remove_column :volunteers, :date
    add_column :volunteers, :date, :date
  end

  def down
    remove_column :volunteers, :date
    add_column :volunteers, :date, :string
  end
end
