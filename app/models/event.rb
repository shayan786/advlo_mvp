class Event < ActiveRecord::Base
	belongs_to :adventure
	has_many :reservations
end
