class AdventureStepsController < ApplicationController
  include Wicked::Wizard
  steps :basic, :gallery

  def show
    @adventure = Adventure.find_by_id(session[:adventure_id])
    render_wizard
  end


  def update
    @adventure = Adventure.find_by_id(session[:adventure_id])
    @adventure.attributes = adventure_params
    render_wizard @adventure
  end

  private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def adventure_params
    params.required(:adventure).permit(:title, :subtitle, :attachment, :location)
  end
end
