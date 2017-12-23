class AddingOpenOffesneToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :open_offense, :boolean, :deafult => false
  end
end
