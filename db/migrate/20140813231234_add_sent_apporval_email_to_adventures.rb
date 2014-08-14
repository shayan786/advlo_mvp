class AddSentApporvalEmailToAdventures < ActiveRecord::Migration
  def change
    add_column :adventures, :sent_approval_email, :boolean, :default => false
  end
end
