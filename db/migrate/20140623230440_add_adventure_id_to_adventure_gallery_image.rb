class AddAdventureIdToAdventureGalleryImage < ActiveRecord::Migration
  def change
    add_column :adventure_gallery_images, :adventure_id, :integer
  end
end
