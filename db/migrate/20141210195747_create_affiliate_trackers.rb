class CreateAffiliateTrackers < ActiveRecord::Migration
  def change
    create_table :affiliate_trackers do |t|
      t.integer :referrer_id
      t.integer :clicks
      t.integer :sign_ups

      t.timestamps
    end
  end
end
