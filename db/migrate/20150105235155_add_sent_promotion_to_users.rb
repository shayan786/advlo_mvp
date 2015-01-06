class AddSentPromotionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sent_promotion, :boolean, default: false
  end
end
