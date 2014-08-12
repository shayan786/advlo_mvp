class AddAdventureIdToFlags < ActiveRecord::Migration
  def change
    add_column :flags, :adventure_id, :integer
  end
end
