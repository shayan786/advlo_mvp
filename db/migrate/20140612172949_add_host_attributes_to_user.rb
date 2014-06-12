class AddHostAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :skillset, :string
    add_column :users, :language, :string
    add_column :users, :sex, :string
    add_column :users, :age, :integer
    add_column :users, :is_guide, :boolean
    add_column :users, :bio, :text
  end
end
