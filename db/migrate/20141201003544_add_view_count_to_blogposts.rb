class AddViewCountToBlogposts < ActiveRecord::Migration
  def change
    add_column :blogposts, :view_count, :integer
  end
end
