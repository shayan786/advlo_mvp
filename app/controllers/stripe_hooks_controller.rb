class StripeHooksController < ApplicationController
  protect_from_forgery :except => :receiver


  def receiver 

    receiving_data = JSON.parse request.body.read

    puts receiving_data['data']['object']
    puts receiving_data.inspect


    respond_to do |format|
      format.json {render json: {status: 200}}
    end 
  end
  

end

