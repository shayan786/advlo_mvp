ActiveAdmin.register Adventure do

  index do
    column :title
    column :subtitle
    column 'attachment' do |adv|
      image_tag(adv.attachment(:thumb))
    end
    actions
  end

  form multipart: true do |f|
    f.inputs do
      f.input :title
      f.input :slug
      f.input :subtitle
      f.input :attachment, as: :file
      f.has_many :user_adventures do |app|
        app.input :user_id, as: :select, collection: User.all.map{|u| ["#{u.email}", u.id]}
        app.input :_destroy, :as=>:boolean, :required => false, :label=>'Remove'
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
