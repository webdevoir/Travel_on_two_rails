class CreateDonationGoals < ActiveRecord::Migration[5.0]
  def change
    create_table :donation_goals do |t|
      t.float :amount
      t.integer :trip_id
      t.timestamps
    end
  end
end
