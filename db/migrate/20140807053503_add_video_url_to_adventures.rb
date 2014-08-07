class AddVideoUrlToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :video_url, :string
  end
end
