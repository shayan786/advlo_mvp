class AddBudgetAndDatesToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :budget, :string
    add_column :requests, :dates, :string
  end
end
