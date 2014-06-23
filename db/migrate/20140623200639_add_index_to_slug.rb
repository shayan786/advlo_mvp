class AddIndexToSlug < ActiveRecord::Migration
  def change
    add_index :adventures, :slug
  end
end
