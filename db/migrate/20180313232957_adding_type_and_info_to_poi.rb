class AddingTypeAndInfoToPoi < ActiveRecord::Migration[5.0]
  def change
    add_column :point_of_interests, :type, :string
    add_column :point_of_interests, :info, :text
  end
end
