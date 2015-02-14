class AddGuideTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :guide_type, :string, default: ''
  end
end
