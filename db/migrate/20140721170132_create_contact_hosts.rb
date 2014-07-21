class CreateContactHosts < ActiveRecord::Migration
  def change
    create_table :contact_hosts do |t|
      t.integer :user_id
      t.integer :host_id
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
