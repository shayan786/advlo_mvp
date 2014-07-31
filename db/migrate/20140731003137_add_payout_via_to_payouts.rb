class AddPayoutViaToPayouts < ActiveRecord::Migration
  def change
    add_column :payouts, :payout_via, :string
  end
end
