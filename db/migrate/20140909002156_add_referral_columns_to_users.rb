class AddReferralColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :referral_code, :string
    add_column :users, :referrer_id, :integer
  end
end
