class AddBLogIdToBlogImage < ActiveRecord::Migration
  def change
    add_column :blog_images, :blog_id, :integer
  end
end
