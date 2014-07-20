class CreateRequestLocations < ActiveRecord::Migration
  def change
    create_table :request_locations do |t|
      t.string :location
      t.string :email
      t.integer :user_id
      t.text :comments

      t.timestamps
    end
  end
end
