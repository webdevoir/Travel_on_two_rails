class AddingReadToConversationsAndRemoveMessaging < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :read, :boolean, :default => false
    remove_column :messages, :read
  end
end
