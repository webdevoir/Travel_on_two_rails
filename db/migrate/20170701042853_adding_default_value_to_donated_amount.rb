class AddingDefaultValueToDonatedAmount < ActiveRecord::Migration[5.0]
  def change
    change_column :donation_goals, :current_paid, :float, :default => 0
  end
end
