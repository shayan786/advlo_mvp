class AddStripeRecIdAndCustIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_recipient_id, :string
    add_column :users, :stripe_customer_id, :string
  end
end
