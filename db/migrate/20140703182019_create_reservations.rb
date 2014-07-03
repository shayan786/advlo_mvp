class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :user_id
      t.integer :host_id
      t.string :stripe_recipient_id
      t.string :stripe_customer_id
      t.string :stripe_charge_id
      t.integer :total_price
      t.integer :head_count

      t.timestamps
    end
  end
end
