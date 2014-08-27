class AddWaiverIdToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :waiver_id, :integer
  end
end
