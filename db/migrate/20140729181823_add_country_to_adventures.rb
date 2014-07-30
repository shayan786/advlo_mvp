class AddCountryToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :country, :string
  end
end
