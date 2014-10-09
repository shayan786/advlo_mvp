class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :name
      t.string :answer_1
      t.string :answer_2
      t.string :answer_3

      t.timestamps
    end
  end
end
