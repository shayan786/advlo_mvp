class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.integer :user_id
      t.string :type
      t.text :body

      t.timestamps
    end
  end
end
