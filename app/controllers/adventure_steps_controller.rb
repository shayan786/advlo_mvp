class AdventureStepsController < ApplicationController
  include Wicked::Wizard
  steps :basic, :photos, :itinerary

  def show

    if session[:adventure_id] && session[:dashboard == false]
      @adventure = Adventure.find_by_id(session[:adventure_id])
    else
      @adventure = Adventure.find_by_id(params[:adventure_id])
    end

    respond_to do |format|
      format.html {render_wizard}
      format.js {}
    end

  end

  def update
    if session[:adventure_id] && session[:dashboard == false]
      adv_id = session[:adventure_id]
      @adventure = Adventure.find_by_id(adv_id)
    else
      adv_id = params[:adventure_id]
      @adventure = Adventure.find_by_id(adv_id)
    end

    # Hook for uploading pics and remaining on the same page
    if params[:images]
        params[:images].each do |image|
          @adventure.adventure_gallery_images.create(picture: image, adventure_id: adv_id)
        end

      redirect_to "/adventure_steps/photos?adventure_id=#{@adventure.id}", notice: "Photos have been uploaded!"

    # Hook for deleting a pic and remain on the same page
    elsif params[:delete_img] == "1"
      img_id = params[:delete_img_id].to_i
            
      @adv_img_to_delete = @adventure.adventure_gallery_images.find(img_id)
      @adv_img_to_delete.destroy

      respond_to do |format|
        format.js
      end

    elsif params[:add_iten_item] == "1"
      @adventure.itineraries.create(params[:itinerary])

      respond_to do |format|
        format.html {redirect_to "/adventure_steps/itinerary?adventure_id=#{@adventure.id}", notice: "Itenerary has been updated!"}
        format.js {}
      end

    else
      @adventure.attributes = adventure_params
      render_wizard @adventure
    end

  end

  private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def adventure_params
    params.required(:adventure).permit(:title, :subtitle, :attachment, :location, :summary, :cap_min, :cap_max, :price, :price_type, :duration_num, :duration_type, :category, :other_notes, :adventure_gallery_image, :images, :itineraries, :itinerary)
  end
end
