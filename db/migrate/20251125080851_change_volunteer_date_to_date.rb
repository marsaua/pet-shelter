class ChangeVolunteerDateToDate < ActiveRecord::Migration[8.0]
  def up
    change_column :volunteers, :date, :date
  end

  def down
    change_column :volunteers, :date, :string
  end
end
