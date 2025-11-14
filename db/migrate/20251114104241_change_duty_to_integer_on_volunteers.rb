class ChangeDutyToIntegerOnVolunteers < ActiveRecord::Migration[8.0]
  DUTY_MAP = {
    "cleaner" => 0,
    "walker"  => 1,
    "feeder"  => 2
  }
  REVERSE_MAP = DUTY_MAP.invert

  def up
    add_column :volunteers, :duty_int, :integer

    say_with_time "Backfilling volunteers.duty_int from duty" do
      Volunteer.reset_column_information
      Volunteer.find_each do |v|
        v.update_columns(duty_int: DUTY_MAP[v[:duty]])
      end
    end

    remove_column :volunteers, :duty
    rename_column :volunteers, :duty_int, :duty
  end

  def down
    
    add_column :volunteers, :duty_str, :string

    say_with_time "Backfilling volunteers.duty_str from duty (int)" do
      Volunteer.reset_column_information
      Volunteer.find_each do |v|
        v.update_columns(duty_str: REVERSE_MAP[v[:duty]])
      end
    end

    remove_column :volunteers, :duty
    rename_column :volunteers, :duty_str, :duty
  end
end
