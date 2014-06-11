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
      f.input :subtitle
      f.input :attachment, as: :file
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
