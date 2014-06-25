class AdventureStepsController < ApplicationController
  include Wicked::Wizard
  steps :basic, :photos

  def show
    @adventure = Adventure.find_by_id(session[:adventure_id])
    render_wizard
  end

  def update
    @adventure = Adventure.find_by_id(session[:adventure_id])
    @adventure.attributes = adventure_params

    # Hook for uploading pics and remaining on the same page
    if params[:images]
        params[:images].each do |image|
          @adventure.adventure_gallery_images.create(image: image, adventure_id: params[:adventure_id])
        end

      redirect_to '/adventure_steps/photos', notice: "Photos have been uploaded!"
    else
      redirect_to '/adventure_steps/photos', notice: "Something went wrong!"
    end

    render_wizard @adventure
  end

  private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def adventure_params
    params.required(:adventure).permit(:title, :subtitle, :attachment, :location, :summary, :cap_min, :cap_max, :price, :price_type, :duration_num, :duration_type, :category, :other_notes, :adventure_gallery_image, :images)
  end
end
