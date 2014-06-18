class CreateUserAdventures < ActiveRecord::Migration
  def change
    create_table :user_adventures do |t|
      t.integer :user_id
      t.integer :adventure_id

      t.timestamps
    end
  end
end
