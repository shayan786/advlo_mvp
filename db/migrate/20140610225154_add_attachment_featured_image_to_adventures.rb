class AddAttachmentFeaturedImageToAdventures < ActiveRecord::Migration
  def self.up
    change_table :adventures do |t|
      t.attachment :featured_image
    end
  end

  def self.down
    drop_attached_file :adventures, :featured_image
  end
end
