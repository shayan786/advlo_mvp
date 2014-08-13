class Flag < ActiveRecord::Base
  belongs_to :user
  belongs_to :adventure
  belongs_to :reservation

end
