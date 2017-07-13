class WoopsChaningBack < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :read, :boolean, :default => false
    remove_column :conversations, :read
  end
end
