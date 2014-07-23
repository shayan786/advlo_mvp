class AddDefaultRatingToAdventureAndUsers < ActiveRecord::Migration
  def change
    change_column :adventures, :rating, :default => ''
    change_column :users, :rating, :default => ''
  end
end
