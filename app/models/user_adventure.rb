class UserAdventure < ActiveRecord::Base
  belongs_to :user
  belongs_to :adventure

end
