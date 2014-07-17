class AddEventTimeToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :event_start_time, :datetime
  end
end
