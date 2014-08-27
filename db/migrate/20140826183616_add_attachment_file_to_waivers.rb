class AddAttachmentFileToWaivers < ActiveRecord::Migration
  def self.up
    change_table :waivers do |t|
      t.attachment :file
    end
  end

  def self.down
    drop_attached_file :waivers, :file
  end
end
