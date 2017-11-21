class AddStripePaidFieldToTransaction < ActiveRecord::Migration[5.0]
  def change
    add_column :purchases, :paid, :boolean, default: false
    add_column :purchases, :stripe_charge, :string
  end
end
