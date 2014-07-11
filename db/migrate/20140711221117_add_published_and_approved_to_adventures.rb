class AddPublishedAndApprovedToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :published, :boolean
    add_column :adventures, :approved, :boolean
  end
end
