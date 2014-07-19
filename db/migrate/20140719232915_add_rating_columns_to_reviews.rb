class AddRatingColumnsToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :adv_rating, :string
    add_column :reviews, :host_rating, :string
  end
end
