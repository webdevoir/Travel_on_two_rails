class CreatePostGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :post_groups do |t|
      t.string :month
      t.string :year
      t.integer :image
      t.timestamps
    end
  end
end
