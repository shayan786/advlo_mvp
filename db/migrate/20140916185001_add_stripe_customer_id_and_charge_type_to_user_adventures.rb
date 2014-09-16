class AddStripeCustomerIdAndChargeTypeToUserAdventures < ActiveRecord::Migration
  def change
    add_column :user_adventures, :stripe_customer_id, :string
    add_column :user_adventures, :charge_type, :string
  end
end
