class AddCategoryToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :category, :string
  end
end
