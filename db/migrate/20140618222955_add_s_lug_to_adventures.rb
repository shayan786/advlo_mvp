class AddSLugToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :slug, :string
  end
end
