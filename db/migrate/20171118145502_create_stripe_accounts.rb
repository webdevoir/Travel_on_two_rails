class CreateStripeAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_accounts do |t|
      t.integer :user_id
      t.string :provider
      t.string :access_code
      t.string :publishable_key
      t.string :uid
      t.timestamps
    end
  end
end
