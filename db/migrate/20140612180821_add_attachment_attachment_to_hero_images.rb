class AddAttachmentAttachmentToHeroImages < ActiveRecord::Migration
  def self.up
    change_table :hero_images do |t|
      t.attachment :attachment
    end
  end

  def self.down
    drop_attached_file :hero_images, :attachment
  end
end
