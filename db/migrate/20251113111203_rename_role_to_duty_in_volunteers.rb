class RenameRoleToDutyInVolunteers < ActiveRecord::Migration[8.0]
  def change
    rename_column :volunteers, :role, :duty
  end
end
