class Reservation < ActiveRecord::Base
  belongs_to :event
	belongs_to :adventure
	belongs_to :user

  accepts_nested_attributes_for :user, :event
end
