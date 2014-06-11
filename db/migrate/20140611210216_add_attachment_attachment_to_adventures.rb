class AddAttachmentAttachmentToAdventures < ActiveRecord::Migration
  def self.up
    change_table :adventures do |t|
      t.attachment :attachment
    end
  end

  def self.down
    drop_attached_file :adventures, :attachment
  end
end
