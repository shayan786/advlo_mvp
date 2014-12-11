class AddDefaultToAffilliateTracker < ActiveRecord::Migration
  def change
    change_column_default :affiliate_trackers, :sign_ups, 0
    change_column_default :affiliate_trackers, :clicks, 0
  end
end
