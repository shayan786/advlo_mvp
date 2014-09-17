class AddStripeSubscriptionIdToUserAdventures < ActiveRecord::Migration
  def change
    add_column :user_adventures, :stripe_subscription_id, :string
  end
end
