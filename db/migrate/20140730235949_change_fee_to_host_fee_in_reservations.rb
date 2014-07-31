class ChangeFeeToHostFeeInReservations < ActiveRecord::Migration
  def change
    rename_column :reservations, :fee, :host_fee
  end
end
