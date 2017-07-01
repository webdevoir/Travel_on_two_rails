class AddingExtraFieldsToDonationGoals < ActiveRecord::Migration[5.0]
  def change
    add_column :donation_goals, :title, :string
    add_column :donation_goals, :description, :text
    add_column :donation_goals, :end_date, :date
  end
end
