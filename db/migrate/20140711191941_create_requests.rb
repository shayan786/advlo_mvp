class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :user_id
      t.string :email
      t.string :location
      t.text :description
      t.string :category

      t.timestamps
    end
  end
end
