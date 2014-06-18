class AddDateOfBirthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dob, :date
  end
end
