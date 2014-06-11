class RemoveAdventures < ActiveRecord::Migration
  def change
    drop_table :adventures
  end
end
