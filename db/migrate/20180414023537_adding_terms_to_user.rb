class AddingTermsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :terms_accepted_at, :datetime
  end
end
