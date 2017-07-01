class AddingDescriptionAndGearToTrip < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :description, :text
    add_column :trips, :gear_list, :text
    add_column :trips, :bike, :string
  end
end
