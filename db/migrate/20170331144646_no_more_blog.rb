class NoMoreBlog < ActiveRecord::Migration[5.0]
  def change
    drop_table :blogs
    add_column :users, :blog_name, :string
    rename_column :posts, :blog_id, :trip_id
    create_table :trips do |t|
      t.string :trip_name
      t.integer :user_id
    end
  end
end
