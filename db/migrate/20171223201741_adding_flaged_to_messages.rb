class AddingFlagedToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :flagged, :boolean, :default => false
  end
end
