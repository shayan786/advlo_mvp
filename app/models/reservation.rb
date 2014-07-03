class Reservation < ActiveRecord::Base
	belongs_to :event, :user
end
