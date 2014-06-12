ActiveAdmin.register HeroImage do
  index do
    column :location
    column :region
    column "Image" do |p|
      if p.attachment
        image_tag (p.attachment.url(:thumb))
      end
    end
    actions
  end

  

  form multipart: true do |f|
    f.inputs do
      f.input :location
      f.input :region, as: :select, collection: ['Colorado', 'Thailand', 'Hawaii']
      f.input :attachment, :as => :file, :label => 'Upload Image'
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end