class AddSocialUrlsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_url, :string
    add_column :users, :tw_url, :string
    add_column :users, :li_url, :string
  end
end
