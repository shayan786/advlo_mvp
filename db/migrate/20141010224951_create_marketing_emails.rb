class CreateMarketingEmails < ActiveRecord::Migration
  def change
    create_table :marketing_emails do |t|
      t.integer :user_id
      t.string :title

      t.timestamps
    end
  end
end
