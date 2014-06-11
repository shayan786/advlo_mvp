class CreateAdventures < ActiveRecord::Migration
  def change
    create_table :adventures do |t|
      t.string :title
      t.string :subtitle

      t.timestamps
    end
  end
end
