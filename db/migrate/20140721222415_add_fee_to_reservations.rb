class AddFeeToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :fee, :float
  end
end
