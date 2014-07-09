class Review < ActiveRecord::Base
  belongs_to :adventure
  belongs_to :user

end
