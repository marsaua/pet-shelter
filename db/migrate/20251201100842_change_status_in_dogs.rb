
class ChangeStatusInDogs < ActiveRecord::Migration[8.0]
  def up
    add_column :dogs, :status_temp, :integer, default: 0

    Dog.reset_column_information
    Dog.find_each do |dog|
      case dog.status
      when "available"
        dog.update_column(:status_temp, 0)
      when "adopted"
        dog.update_column(:status_temp, 3)
      else
        dog.update_column(:status_temp, 0)
      end
    end

    remove_column :dogs, :status

    rename_column :dogs, :status_temp, :status
  end

  def down
    add_column :dogs, :status_temp, :string

    Dog.reset_column_information
    Dog.find_each do |dog|
      case dog.status
      when 0
        dog.update_column(:status_temp, "available")
      when 3
        dog.update_column(:status_temp, "adopted")
      end
    end

    remove_column :dogs, :status
    rename_column :dogs, :status_temp, :status
  end
end
