class AddReasonAndCancelToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :cancelled, :boolean, :default => false
    add_column :reservations, :cancel_reason, :text
  end
end
