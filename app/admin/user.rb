ActiveAdmin.register User do
  
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

  index do
    column :email
    column :name
    column 'avatar' do |user|
      if user.avatar_url
        image_tag user.avatar_url
      elsif user.avatar
        image_tag(user.avatar.url(:thumb)
      end
    end
    column 'referrer' do |ref|
      if user.referrer_id
        referrer = User.find(user.referrer_id)
        referrer.get_name_or_email
      else
        "-"
      end
    end
    actions
  end

  form multipart: true do |f|
    f.inputs do
      f.input :is_guide
      f.input :email
      f.input :name
      f.input :rating, collection: ['1','2','3','4','5']
      f.input :avatar_url
      f.input :avatar, as: :file
      f.input :location
      f.input :skillset
      f.input :language
      f.input :sex
      f.input :age
      f.input :bio
      f.input :dob
      f.input :short_description
      f.input :video_url
      f.input :fb_url
      f.input :tw_url
      f.input :ta_url
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
