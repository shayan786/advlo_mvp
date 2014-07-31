class AddUserFeeToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :user_fee, :float
  end
end
