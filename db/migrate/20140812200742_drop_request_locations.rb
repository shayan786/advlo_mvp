class DropRequestLocations < ActiveRecord::Migration
  
  def change
    drop_table :request_locations
  end
end
