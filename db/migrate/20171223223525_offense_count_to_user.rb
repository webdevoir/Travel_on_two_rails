class OffenseCountToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :offense_count, :integer, :default => 0
  end
end
