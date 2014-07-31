class ChangeAmountFromIntegerToFloatInPayouts < ActiveRecord::Migration
  def change
    change_column :payouts, :amount, :float
  end
end
