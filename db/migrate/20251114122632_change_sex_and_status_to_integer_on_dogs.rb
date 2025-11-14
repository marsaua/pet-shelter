class ChangeSexAndStatusToIntegerOnDogs < ActiveRecord::Migration[8.0]
  SEX_MAP    = { "male" => 0, "female" => 1 }.freeze
  STATUS_MAP = { "available" => 0, "adopted" => 1 }.freeze
  SIZE_MAP   = { "small" => 0, "medium" => 1, "large" => 2 }.freeze

  def up
    add_column :dogs, :sex_int, :integer
    add_column :dogs, :status_int, :integer
    add_column :dogs, :size_int, :integer

    execute <<~SQL
      UPDATE dogs
      SET sex_int = CASE LOWER(COALESCE(sex,'')) 
        WHEN 'male'   THEN 0
        WHEN 'female' THEN 1
        ELSE NULL
      END
    SQL

    execute <<~SQL
      UPDATE dogs
      SET status_int = CASE LOWER(COALESCE(status,'')) 
        WHEN 'available' THEN 0
        WHEN 'adopted'   THEN 1
        ELSE NULL
      END
    SQL

    execute <<~SQL
      UPDATE dogs
      SET size_int = CASE LOWER(COALESCE(size,'')) 
        WHEN 'small'  THEN 0
        WHEN 'medium' THEN 1
        WHEN 'large'  THEN 2
        ELSE NULL
      END
    SQL

    execute "UPDATE dogs SET sex_int = 0    WHERE sex_int IS NULL"
    execute "UPDATE dogs SET status_int = 0 WHERE status_int IS NULL"
    execute "UPDATE dogs SET size_int = 0   WHERE size_int IS NULL"
    remove_column :dogs, :sex
    remove_column :dogs, :status
    remove_column :dogs, :size
    rename_column :dogs, :sex_int, :sex
    rename_column :dogs, :status_int, :status
    rename_column :dogs, :size_int, :size

    change_column_null    :dogs, :sex,    false
    change_column_default :dogs, :sex,    from: nil, to: 0

    change_column_null    :dogs, :status, false
    change_column_default :dogs, :status, from: nil, to: 0

    change_column_null    :dogs, :size,   false
    change_column_default :dogs, :size,   from: nil, to: 0
  end

  def down
    add_column :dogs, :sex_str,    :string
    add_column :dogs, :status_str, :string
    add_column :dogs, :size_str,   :string
    execute <<~SQL
      UPDATE dogs
      SET sex_str = CASE sex
        WHEN 0 THEN 'male'
        WHEN 1 THEN 'female'
        ELSE NULL
      END
    SQL

    execute <<~SQL
      UPDATE dogs
      SET status_str = CASE status
        WHEN 0 THEN 'available'
        WHEN 1 THEN 'adopted'
        ELSE NULL
      END
    SQL

    execute <<~SQL
      UPDATE dogs
      SET size_str = CASE size
        WHEN 0 THEN 'small'
        WHEN 1 THEN 'medium'
        WHEN 2 THEN 'large'
        ELSE NULL
      END
    SQL

    remove_column :dogs, :sex
    remove_column :dogs, :status
    remove_column :dogs, :size
    rename_column :dogs, :sex_str,    :sex
    rename_column :dogs, :status_str, :status
    rename_column :dogs, :size_str,   :size
  end
end
