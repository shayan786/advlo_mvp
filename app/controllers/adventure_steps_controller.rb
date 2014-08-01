class AdventureStepsController < ApplicationController
  include ApplicationHelper
  include Wicked::Wizard
  steps :basic, :photos, :itinerary, :schedule, :payment, :publish

  def show

    if session[:adventure_id]
      @adventure = Adventure.find_by_id(session[:adventure_id])
    else
      @adventure = Adventure.find_by_id(params[:adventure_id])
    end
    
    session[:adventure_id] =  @adventure.id

    # Prevent URL injection
    case params[:id]

    when "basic"
      respond_to do |format|
        format.html {render_wizard}
        format.js {}
      end

    when "photos"
      if !@adventure.title.nil?
        respond_to do |format|
          format.html {render_wizard}
          format.js {}
        end
      else
        redirect_to "/adventure_steps/basic?adventure_id=#{@adventure.id}", notice: "Please complete the basic adventure information first"
      end
    when "itinerary"
      if !@adventure.adventure_gallery_images.empty?
        respond_to do |format|
          format.html {render_wizard}
          format.js {}
        end
      else
        redirect_to "/adventure_steps/photos?adventure_id=#{@adventure.id}", notice: "Please upload atleast one photo of your adventure"
      end

    when "schedule"
      if !@adventure.adventure_gallery_images.empty?
        respond_to do |format|
          format.html {render_wizard}
          format.js {}
        end
      else
        redirect_to "/adventure_steps/photos?adventure_id=#{@adventure.id}", notice: "Please upload atleast one photo of your adventure"
      end

    when "payment"
      if !@adventure.events.empty?
        respond_to do |format|
          format.html {render_wizard}
          format.js {}
        end
      else
        redirect_to "/adventure_steps/schedule?adventure_id=#{@adventure.id}", notice: "Please add atleast one instant reservation for this adventure"
      end

    else
      if current_user.stripe_recipient_id || current_user.paypal_email
        respond_to do |format|
          format.html {render_wizard}
          format.js {}
        end
      else
        redirect_to "/adventure_steps/payment?adventure_id=#{@adventure.id}", notice: "Please add a bank account for this adventure"
      end
    end

  end

  def update
    if session[:adventure_id]
      adv_id = session[:adventure_id]
      @adventure = Adventure.find_by_id(adv_id)
    else
      adv_id = params[:adventure_id]
      @adventure = Adventure.find_by_id(adv_id)
    end

    if params[:published] == '1'
    # Published a Finished Adventure

      @adventure.published = true
      render_wizard @adventure

      AdvloMailer.adventure_approval_request(@adventure).deliver
      AdvloMailer.adventure_approval_confirmation(@adventure).deliver

    elsif params[:published] == '2'
    # Un-Publish an Adventure

      @adventure.published = false
      render_wizard @adventure

    # Hook for uploading pics and remaining on the same page
    elsif params[:images]
      # No more than 10 images allowed
      if @adventure.adventure_gallery_images.count < 11

        params[:images].each do |image|
          @adventure.adventure_gallery_images.create(picture: image, adventure_id: adv_id)
        end

        respond_to do |format|
          format.html {redirect_to "/adventure_steps/photos?adventure_id=#{@adventure.id}", notice: "Photos have been uploaded!"}
          format.js {}
        end
      else
        redirect_to "/adventure_steps/photos?adventure_id=#{@adventure.id}", notice: "You already have 10 images uploaded, please delete some before uploading any more"
      end

    # Hook for deleting a pic and remain on the same page
    elsif params[:delete_img] == "1"
      img_id = params[:delete_img_id].to_i
            
      @adv_img_to_delete = @adventure.adventure_gallery_images.find(img_id)
      @adv_img_to_delete.destroy

      respond_to do |format|
        format.js {}
      end

    # Hook for adding a itinerary item and remain on the same page
    elsif params[:add_iten_item] == "1"
      @adventure.itineraries.create(headline: params[:headline], description: params[:description], adventure_id: @adventure.id)

      respond_to do |format|
        format.html {redirect_to "/adventure_steps/itinerary?adventure_id=#{@adventure.id}", notice: "Itinerary event '#{params[:headline]}' has been created!"}
        format.js { render action: 'create_itin.js', layout: false}
      end

    # Hook for updating/deleting itinerary item and remain on the same page
    elsif params[:update_iten_item] == "1"
      @iten_id = params[:iten_id].to_i
      @adv_iten_item = @adventure.itineraries.find(@iten_id)
      
      # Delete the iten item
      if params[:delete] == "1"
        @adv_iten_item.destroy

        respond_to do |format|
          format.html {redirect_to "/adventure_steps/itinerary?adventure_id=#{@adventure.id}", notice: "Itinerary event '#{@adv_iten_item.headline}' has been deleted!"}
          format.js { render action: 'del_iten.js', layout: false}
        end
      end
      # Update the iten item
      if params[:update] == "1"
        @adv_iten_item.update(headline: params[:headline], description: params[:description])

        respond_to do |format|
          format.html {redirect_to "/adventure_steps/itinerary?adventure_id=#{@adventure.id}", notice: "Itinerary event '#{@adv_iten_item.headline}' has been updated!"}
          format.js { render action: 'update_iten.js', layout: false}
        end
      end

    # Hook for bank + interaction with stripe (will only happen if recipient does not exist from view)
    elsif params[:bank_cc_add] == "1"
      user = User.find_by_id(params[:host_id])

      # Hook if you want to change you current bank account (also implies you have a recipient id)
      if params[:bank_cc_update] == "1"
        recipient = Stripe::Recipient.retrieve(user.stripe_recipient_id)

        recipient.bank_account = params[:update_stripe_token]
        recipient.name = params[:recipient][:bank_account_name]

        recipient.save
        @updated_recipient = recipient

        respond_to do |format|
          format.js {render "payment_update.js", layout: false}
        end
      else
        # Create new recipient
        recipient = Stripe::Recipient.create(
          :name => params[:recipient][:bank_account_name],
          :type => "individual",
          :email => params[:recipient][:email],
          :bank_account => params[:stripe_token]
        )

        # Add recipient id to the user
        user.update(stripe_recipient_id: recipient.id)

        @recipient = Stripe::Recipient.retrieve(recipient.id)

        respond_to do |format|
          format.js {render "payment.js", layout: false}
        end
      end
    # Hook for paypal email address addition
    elsif params[:paypal] == "1"
      user = User.find_by_id(params[:host_id])
      user.update(paypal_email: params[:paypal_email])

      respond_to do |format|
        if params[:paypal_update] == "1"
          format.js {render "paypal_update.js", layout: false}
        else
          format.js {render "paypal.js", layout: false}
        end
      end

    # For updating the 'basic' info
    else
      @adventure.attributes = adventure_params
      @adventure.category = params[:category].join(",")

      # For updating the region
      continent = get_continent(params[:adventure][:region]);
      @adventure.update(region: continent)
      
      render_wizard @adventure
    end

  rescue Stripe::InvalidRequestError => e
    flash[:notice] = e.message
  end

  private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  
  def redirect_to_finish_wizard(options = nil)
    redirect_to "/adventures/#{@adventure.slug}", notice: "PENDING APPROVAL: We’ll notify you when it goes live"
  end

  def adventure_params
    params.required(:adventure).permit(:title, :subtitle, :attachment, :region, :location, :summary, :cap_min, :cap_max, :price, :price_type, :duration_num, :duration_type, :other_notes, :adventure_gallery_image, :images, :itineraries, :itinerary, :headline, :description, :latitude, :longitude, :published, :category => [])
  end


end
