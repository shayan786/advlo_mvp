class UsersController < ApplicationController

  def index
    @user = User.all
  end

  def show
    @user = User.find(params[:id])
    @user_languages = @user.language.split(',')
    @user_skillsets = @user.skillset.split(',')

    @reviews = Review.where(host_id: @user.id)
  end

  # Messaging the host through the profile show page
  def contact_host
    @contact = ContactHost.create!(contact_host_params)
    
    if @contact.save
      # Mail the host to be messaged
      # AdvloMailer.delay.contact_host_email(params[:contact_host][:email])
      # AdvloMailer.contact_host_email(params[:contact_host][:email]).deliver

      respond_to do |format|
        format.js {render "contact_host.js", layout: false}
      end
    end
  end 

  private 

  def contact_host_params
    params.required(:contact_host).permit(:user_id, :host_id, :message, :email)
  end

end

