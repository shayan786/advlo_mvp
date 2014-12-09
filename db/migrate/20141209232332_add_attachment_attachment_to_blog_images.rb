class AddAttachmentAttachmentToBlogImages < ActiveRecord::Migration
  def self.up
    change_table :blog_images do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :blog_images, :attachment
  end
end
