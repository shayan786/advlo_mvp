ActiveAdmin.register Adventure do
  action_item :only => :index do
    link_to 'Upload CSV', :action => 'upload_csv'
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, :method => :post do
    CsvDb.convert_save("adventure", params[:dump][:file])
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end


  before_filter :only => [:show, :edit, :update, :destroy] do
    @adventure = Adventure.find_by_title(params[:id])
  end

  index do
    column :title
    column :published
    column :approved
    column :category
    column :region
    column 'Email' do |adv|
      adv.users.first.email if adv.users.first
    end
    column 'Guide' do |adv|
      adv.users.first.name if adv.users.first
    end
    column 'Guide pic' do |adv|
      if adv.users.first && adv.users.first.avatar_url
        image_tag adv.users.first.avatar_url
      elsif adv.users.first
        image_tag(adv.users.first.avatar(:thumb))
      end
    end
    column 'attachment' do |adv|
      image_tag(adv.attachment(:thumb)) if adv.attachment
    end
    actions
  end

  form multipart: true do |f|
    f.inputs do
      f.input :title
      f.input :rating, collection: ['1','2','3','4','5']
      f.input :published
      f.input :approved
      f.input :featured
      f.input :slug, label: 'permalink'
      f.input :summary
      f.input :location
      f.input :city
      f.input :region, collection: adv_regions
      f.input :category
      f.input :price
      f.input :price_type, as: :select, collection: ["per_person", "per_adventure"]
      f.input :video_url
      f.input :attachment, as: :file
      f.has_many :user_adventures do |app|
        app.input :user_id, as: :select, collection: User.all.map{|u| ["#{u.email}", u.id]}, label: 'Guide'
        app.input :_destroy, :as=>:boolean, :required => false, :label=>'Remove'
      end
      f.has_many :itineraries do |app|
        app.input :headline
        app.input :description
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
