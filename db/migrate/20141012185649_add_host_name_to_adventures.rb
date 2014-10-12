class AddHostNameToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :host_name, :string
  end
end
