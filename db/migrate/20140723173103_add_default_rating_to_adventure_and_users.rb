class AddDefaultRatingToAdventureAndUsers < ActiveRecord::Migration
  def change
    change_column_default :adventures, :rating, ''
    change_column_default :users, :rating, ''
  end
end
