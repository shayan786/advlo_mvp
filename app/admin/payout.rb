ActiveAdmin.register Payout do
  index do
    column :user_id
    column :amount
    actions
  end


  form multipart: true do |f|
    f.inputs do
      f.input :user_id
      f.input :stripe_recipient_id
      f.input :stripe_transfer_id
      f.input :amount
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
