class AddAttachmentPictureToAdventureGalleryImages < ActiveRecord::Migration
  def self.up
    change_table :adventure_gallery_images do |t|
      t.attachment :picture
    end
  end

  def self.down
    drop_attached_file :adventure_gallery_images, :picture
  end
end
