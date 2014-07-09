class AddAdventureIdToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :adventure_id, :integer
  end
end
