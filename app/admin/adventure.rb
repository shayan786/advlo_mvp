ActiveAdmin.register Adventure do

  index do
    column :title
    column :subtitle
    actions
  end

  form multipart: true do |f|
    f.inputs do
      f.input :title
      f.input :subtitle
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
