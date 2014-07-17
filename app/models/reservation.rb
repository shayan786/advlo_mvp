class Reservation < ActiveRecord::Base
  belongs_to :event
	belongs_to :adventure
  belongs_to :user
	belongs_to :payout

  accepts_nested_attributes_for :user, :event
end
