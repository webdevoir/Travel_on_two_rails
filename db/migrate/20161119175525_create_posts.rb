class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :post_title
      t.string :post_content
      t.integer :blog_id
      t.timestamps
    end
  end
end
