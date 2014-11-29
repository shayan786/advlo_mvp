class AddAttachmentAttachmentToBlogposts < ActiveRecord::Migration
  def self.up
    change_table :blogposts do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :blogposts, :attachment
  end
end
