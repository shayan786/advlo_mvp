class AddUserIdToHeroImage < ActiveRecord::Migration
  def change
    add_column :hero_images, :user_id, :integer
  end
end
