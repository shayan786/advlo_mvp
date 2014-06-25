ActiveAdmin.register User do

  index do
    column :email
    column :name
    column :is_guide
    column 'avatar' do |user|
      image_tag(user.avatar(:thumb))
    end
    actions
  end

  form multipart: true do |f|
    f.inputs do
      f.input :is_guide
      f.input :email
      f.input :name
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
      f.input :fb_url
      f.input :tw_url
      f.input :li_url
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
