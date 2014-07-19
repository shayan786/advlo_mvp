class AddRegionToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :region, :string
  end
end
