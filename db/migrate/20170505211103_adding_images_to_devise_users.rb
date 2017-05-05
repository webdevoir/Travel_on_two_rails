class AddingImagesToDeviseUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cover, :string
    add_column :users, :avatar, :string
  end
end
