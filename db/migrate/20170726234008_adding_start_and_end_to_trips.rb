class AddingStartAndEndToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :start, :string
    add_column :trips, :end, :string
  end
end
