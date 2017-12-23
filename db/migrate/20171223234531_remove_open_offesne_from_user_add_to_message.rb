class RemoveOpenOffesneFromUserAddToMessage < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :open_offense
    add_column :messages, :open_offense, :boolean, :default => false
  end
end
