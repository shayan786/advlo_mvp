class CreateBlogposts < ActiveRecord::Migration
  def change
    create_table :blogposts do |t|
      t.string :title
      t.string :author
      t.text :body
      t.string :video_url
      t.string :permalink
      t.string :state

      t.timestamps
    end
  end
end
