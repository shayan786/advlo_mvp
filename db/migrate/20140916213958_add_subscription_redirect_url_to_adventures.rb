class AddSubscriptionRedirectUrlToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :subscription_redirect_url, :string
  end
end
