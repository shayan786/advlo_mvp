class AddRatingToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :rating, :string
  end
end
