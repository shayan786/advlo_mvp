class ChangeCreditToFloat < ActiveRecord::Migration
  def change
    change_column :users, :credit, :float
  end
end
