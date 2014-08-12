class AddReservationIdToFlags < ActiveRecord::Migration
  def change
    add_column :flags, :reservation_id, :integer
  end
end
