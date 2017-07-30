class AddingCenterPointToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :center_lat, :string
    add_column :posts, :center_lng, :string
  end
end
