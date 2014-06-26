class CreateItineraries < ActiveRecord::Migration
  def change
    create_table :itineraries do |t|
      t.string :headline
      t.text :description
      t.integer :adventure_id

      t.timestamps
    end
  end
end
