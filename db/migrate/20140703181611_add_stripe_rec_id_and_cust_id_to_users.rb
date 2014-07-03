class AddStripeRecIdAndCustIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :users, :string
    add_column :users, :stripe_recip_id, :integer
    add_column :users, :strip_cust_id, :integer
  end
end
