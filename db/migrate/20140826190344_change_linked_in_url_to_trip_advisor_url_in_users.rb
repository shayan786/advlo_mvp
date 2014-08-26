class ChangeLinkedInUrlToTripAdvisorUrlInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :li_url, :ta_url
  end
end
