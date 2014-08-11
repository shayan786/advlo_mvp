class ChangeTotalPriceToFloatFromInteger < ActiveRecord::Migration
  def change
    change_column :reservations, :total_price, :float
  end
end
