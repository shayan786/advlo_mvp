class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :email
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
