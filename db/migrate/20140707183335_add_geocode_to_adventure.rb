class AddGeocodeToAdventure < ActiveRecord::Migration
  def change
    add_column :adventures, :latitude, :float
    add_column :adventures, :longitude, :float
  end
end
