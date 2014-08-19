class AddAttachmentMetaToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :attachment_meta, :text
  end
end
