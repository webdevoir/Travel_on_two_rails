class AddDistanceToRoute < ActiveRecord::Migration[5.0]
  def change
    add_column :routes, :distance, :integer
  end
end
