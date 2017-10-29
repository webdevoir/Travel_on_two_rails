class AddTimestampsToTrip < ActiveRecord::Migration[5.0]
  def change_table
    add_column :trips, :created_at, :datetime, null: false
    add_column :trips, :updated_at, :datetime, null: false
  end
end
