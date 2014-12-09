class RemoveBlogIdFromBlogImages < ActiveRecord::Migration
  def change
    rename_column :blog_images, :blog_id, :blogpost_id
  end
end
