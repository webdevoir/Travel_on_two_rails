class AddingCurrentPaidToDonationGoal < ActiveRecord::Migration[5.0]
  def change
    add_column :donation_goals, :current_paid, :float
  end
end
