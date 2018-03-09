class CreatePointOfInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :point_of_interests do |t|
      t.integer :route_id
      t.string :latitude
      t.string :longitude
      t.timestamps
    end
    add_column :posts, :route_id, :integer
  end
end
