class AddEmailToMarketingEmails < ActiveRecord::Migration
  def change
    add_column :marketing_emails, :email, :string
  end
end
