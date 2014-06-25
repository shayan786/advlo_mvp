ActiveAdmin.register Adventure do

  before_filter :only => [:show, :edit, :update, :destroy] do
    @adventure = Adventure.find_by_title(params[:id])
  end

  index do
    column :title
    column :slug
    column :subtitle
    column :location
    column :price
    column :price_type
    column 'Guide' do |adv|
      adv.users.first.email if adv.users.first
    end
    column 'Guide pic' do |adv|
      image_tag adv.users.first.avatar(:thumb) if adv.users.first
    end
    column 'attachment' do |adv|
      image_tag(adv.attachment(:thumb))
    end
    actions
  end

  form multipart: true do |f|
    f.inputs do
      f.input :title
      f.input :slug, label: 'permalink'
      f.input :subtitle
      f.input :location
      f.input :price
      f.input :price_type, as: :select, collection: ["per_person", "per_adv"]
      f.input :summary
      f.input :attachment, as: :file
      f.has_many :user_adventures do |app|
        app.input :user_id, as: :select, collection: User.all.map{|u| ["#{u.email}", u.id]}, label: 'Guide'
        app.input :_destroy, :as=>:boolean, :required => false, :label=>'Remove'
      end

      f.has_many :adventure_gallery_images do |photo|
        photo.inputs do
          photo.input :picture, :as => :file 
          photo.input :_destroy, :as=>:boolean, :required => false, :label=>'Remove'
        end
      end
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
