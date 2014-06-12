class AdventuresController < ApplicationController

  def index
    # @adventures = Adventure.where(region: params[:region])
    @adventures = Adventure.all
    @hero_image = HeroImage.where(region: 'Colorado').last
  end

  def show
    @adventure = Adventure.find(params[:id])
  end


  private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def appointment_params
    params.required(:adventure).permit(:title, :subtitle, :attachment)
  end
end

