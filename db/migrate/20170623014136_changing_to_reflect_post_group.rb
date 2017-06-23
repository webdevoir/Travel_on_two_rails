class ChangingToReflectPostGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :post_groups, :trip_id, :integer
    add_column :posts, :post_group_id, :integer
    add_column :posts, :day, :string
  end
end
