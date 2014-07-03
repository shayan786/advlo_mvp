class AddEventIdToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :event_id, :integer
  end
end
