class AddRequestedToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :requested, :boolean, :default => false
  end
end
