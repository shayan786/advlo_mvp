class CreateContactAdvlos < ActiveRecord::Migration
  def change
    create_table :contact_advlos do |t|
      t.integer :user_id
      t.string :email
      t.text :comments

      t.timestamps
    end
  end
end
