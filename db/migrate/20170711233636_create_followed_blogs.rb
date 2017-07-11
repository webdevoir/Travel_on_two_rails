class CreateFollowedBlogs < ActiveRecord::Migration[5.0]
  def change
    create_table :followed_blogs do |t|
      t.integer :blog_owner_id
      t.integer :user_id
      t.timestamps
    end
  end
end
