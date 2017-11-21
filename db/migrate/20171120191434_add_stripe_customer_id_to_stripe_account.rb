class AddStripeCustomerIdToStripeAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :stripe_accounts, :stripe_customer_id, :string, default: nil
  end
end
