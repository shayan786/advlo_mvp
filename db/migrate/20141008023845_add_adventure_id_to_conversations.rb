class AddAdventureIdToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :adventure_id, :integer
  end
end
