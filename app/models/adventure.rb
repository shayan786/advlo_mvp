class Adventure < ActiveRecord::Base
  before_save :set_slug

  has_many :user_adventures
  has_many :users, through: :user_adventures
  has_many :adventure_gallery_images

  accepts_nested_attributes_for :user_adventures, :adventure_gallery_images, :allow_destroy => true

  has_attached_file :attachment, :styles => { :large => "600x750>", :medium => "325x285>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/

  validates_uniqueness_of :title
  validates_presence_of :title

  def set_slug
    if self.slug == nil || self.slug == ''
      self.slug = self.title.downcase.gsub(' ','').gsub('-','').gsub('.','').gsub("'",'').gsub(":",'')
    end
  end
end
