class CreateHeroImages < ActiveRecord::Migration
  def change
    create_table :hero_images do |t|
      t.string :location
      t.string :region

      t.timestamps
    end
  end
end
