class Waiver < ActiveRecord::Base
  has_attached_file :file
  validates_attachment :file, content_type: { content_type: "application/pdf" }
  validates_attachment_content_type :file, content_type: "application/pdf"

  belongs_to :user
end
