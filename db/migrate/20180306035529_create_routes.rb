class CreateRoutes < ActiveRecord::Migration[5.0]
  def change
    create_table :routes do |t|
      t.string :address1
      t.string :address2
      t.string :center_lat
      t.string :center_lng
      t.text :poly_line
      t.string :address1_lat
      t.string :address1_lng
      t.string :address2_lat
      t.string :address2_lng
      t.boolean :public
      t.timestamps
    end
  end
end
