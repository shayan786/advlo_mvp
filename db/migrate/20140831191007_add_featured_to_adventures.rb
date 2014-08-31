class AddFeaturedToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :featured, :boolean
  end
end
