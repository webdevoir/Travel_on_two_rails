class ChangingPruchaseDonationGoal < ActiveRecord::Migration[5.0]
  def change
    rename_column :purchases, :trip_id, :donation_goal_id
  end
end
