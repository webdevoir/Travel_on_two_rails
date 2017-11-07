class AddingStartAndEndLatLngToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :address1_lat, :string
    add_column :posts, :address1_lng, :string
    add_column :posts, :address2_lat, :string
    add_column :posts, :address2_lng, :string
  end
end
