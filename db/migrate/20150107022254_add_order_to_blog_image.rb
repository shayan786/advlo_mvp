class AddOrderToBlogImage < ActiveRecord::Migration
  def change
    add_column :blog_images, :order, :integer, default: 0
  end
end
