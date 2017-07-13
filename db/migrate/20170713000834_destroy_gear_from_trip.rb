class DestroyGearFromTrip < ActiveRecord::Migration[5.0]
  def change
    remove_column :trips, :gear_list
    remove_column :trips, :bike
    change_column :gear_lists, :other, :text
  end
end
