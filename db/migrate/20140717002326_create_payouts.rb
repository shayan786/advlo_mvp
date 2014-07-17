class CreatePayouts < ActiveRecord::Migration
  def change
    create_table :payouts do |t|
      t.string :status
      t.integer :user_id
      t.string :stripe_recipient_id
      t.string :stripe_transfer_id
      t.integer :amount

      t.timestamps
    end
  end
end
