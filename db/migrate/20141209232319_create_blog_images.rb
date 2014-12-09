class CreateBlogImages < ActiveRecord::Migration
  def change
    create_table :blog_images do |t|
      t.string :caption
      t.string :link
      t.text :excerpt

      t.timestamps
    end
  end
end
