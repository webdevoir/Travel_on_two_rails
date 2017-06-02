class CreatePostPictures < ActiveRecord::Migration[5.0]
  def change
    create_table :post_pictures do |t|
      t.integer :post_id
      t.string :picture
      t.timestamps
    end
  end
end
