class ChaingingPostGroupImageToString < ActiveRecord::Migration[5.0]
  def change
    change_column :post_groups, :image, :string
  end
end
