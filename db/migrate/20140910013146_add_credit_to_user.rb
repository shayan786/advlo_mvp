class AddCreditToUser < ActiveRecord::Migration
  def change
    add_column :users, :credit, :integer, default: 0, null: false
  end
end
