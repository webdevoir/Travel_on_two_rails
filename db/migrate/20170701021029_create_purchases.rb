class CreatePurchases < ActiveRecord::Migration[5.0]
  def change
    create_table :purchases do |t|
      t.integer :buyer_id
      t.integer :trip_id
      t.timestamps
    end
  end
end
