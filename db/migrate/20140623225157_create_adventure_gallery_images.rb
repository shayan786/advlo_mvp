class CreateAdventureGalleryImages < ActiveRecord::Migration
  def change
    create_table :adventure_gallery_images do |t|

      t.timestamps
    end
  end
end
