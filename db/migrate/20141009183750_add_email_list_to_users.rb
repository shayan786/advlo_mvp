class AddEmailListToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_list, :boolean, :default => true
  end
end
