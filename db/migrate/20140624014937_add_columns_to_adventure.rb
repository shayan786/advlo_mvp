class AddColumnsToAdventure < ActiveRecord::Migration
  def change
    add_column :adventures, :location, :string
    add_column :adventures, :summary, :text
    add_column :adventures, :cap_min, :integer
    add_column :adventures, :cap_max, :integer
    add_column :adventures, :price, :integer
    add_column :adventures, :price_type, :string
    add_column :adventures, :duration_num, :integer
    add_column :adventures, :duration_type, :string
    add_column :adventures, :category, :string
    add_column :adventures, :other_notes, :text
  end
end
