class CreateGearLists < ActiveRecord::Migration[5.0]
  def change
    create_table :gear_lists do |t|
      t.integer :trip_id
      t.string :bike
      t.string :tent
      t.string :pannier
      t.string :other
      t.timestamps
    end
  end
end
