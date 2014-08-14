class StripeHooksController < ApplicationController
  protect_from_forgery :except => :receiver


  def receiver 

    receiving_data = JSON.parse request.body.read

    puts receiving_data['data']['object']['status']
    puts receiving_data.inspect

    update_payout(receiving_data)

    respond_to do |format|
      format.json {render json: {status: 200}}
    end 
  end


  private

  def update_payout(receiving_data)
    puts "****"
    puts receiving_data.object.id

    #@payout = Payout.find_by_stripe_transfer_id(receiving_data.object.id)



  end
  

end



