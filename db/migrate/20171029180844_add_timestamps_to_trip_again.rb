class AddTimestampsToTripAgain < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :trips, default: DateTime.now
    change_column_default :trips, :created_at, nil
    change_column_default :trips, :updated_at, nil
  end
end
