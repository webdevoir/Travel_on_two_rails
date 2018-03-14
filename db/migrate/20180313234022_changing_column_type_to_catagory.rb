class ChangingColumnTypeToCatagory < ActiveRecord::Migration[5.0]
  def change
    rename_column :point_of_interests, :type, :category
  end
end
