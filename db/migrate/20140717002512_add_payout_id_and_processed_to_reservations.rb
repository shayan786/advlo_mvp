class AddPayoutIdAndProcessedToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :payout_id, :integer
    add_column :reservations, :processed, :boolean, :default => false
  end
end
