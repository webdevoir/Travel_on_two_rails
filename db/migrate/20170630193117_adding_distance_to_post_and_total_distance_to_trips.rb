class AddingDistanceToPostAndTotalDistanceToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :distance, :integer
    add_column :trips, :total_distance, :integer
  end
end
