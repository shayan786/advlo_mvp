class AddCreditToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :credit, :float, default: 0, null: false
  end
end
