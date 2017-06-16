class AddingAddressToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :country, :string
    add_column :users, :province, :string
    add_column :users, :city, :string
  end
end
