class AddCityAndStateToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :city, :string
    add_column :adventures, :state, :string
  end
end
