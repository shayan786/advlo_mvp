ActiveAdmin.register Itinerary do
  index do
    column :headline
    column :description
    actions
  end

  

  form multipart: true do |f|
    f.inputs do
      f.input :headline
      f.input :description
      f.input :adventure_id, as: :select, collection: Adventure.all.map{|adv| ["#{adv.title}", adv.id]}
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end