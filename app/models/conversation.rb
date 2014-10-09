class Conversation < ActiveRecord::Base
  has_many :messages, dependent: :destroy
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  validates_presence_of :sender_id, :receiver_id
  
end
