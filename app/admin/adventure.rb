ActiveAdmin.register Adventure do

  index do
    column :title
    column :subtitle
    column "Main Image" do |post|
      image_tag(post.featured_image(:thumb)) unless post.featured_image == nil
    end
    actions
  end

  form multipart: true do |f|
    f.inputs do
      f.input :title
      f.input :subtitle
      f.input :featured_image, :as => :file
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end