class AddingPolyLineStringToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :poly_line, :text
  end
end
