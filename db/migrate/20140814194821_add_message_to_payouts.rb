class AddMessageToPayouts < ActiveRecord::Migration
  def change
    add_column :payouts, :message, :text
  end
end
