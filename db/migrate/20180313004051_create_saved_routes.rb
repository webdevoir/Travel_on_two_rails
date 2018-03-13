class CreateSavedRoutes < ActiveRecord::Migration[5.0]
  def change
    create_table :saved_routes do |t|
      t.integer :user_id
      t.integer :route_id
      t.timestamps
    end
  end
end
