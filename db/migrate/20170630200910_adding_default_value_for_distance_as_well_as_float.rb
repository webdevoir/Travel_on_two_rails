class AddingDefaultValueForDistanceAsWellAsFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :trips, :total_distance, :integer, :default => 0
  end
end
