class AddingTripPhoto < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :photo, :string
  end
end
