class StripeHooksController < ApplicationController
  protect_from_forgery :except => :receiver


  def receiver 
    receiving_data = JSON.parse request.body.read

    if receiving_data['data']['type'] == 'transfer.failed'
      puts '******'
      puts 'BLAH BLAHB BLAH'
      update_payout(receiving_data)

      respond_to do |format|
        format.json {render json: {status: 200}}
      end 
    elsif receiving_data['data']['type'] == 'transfer.paid'
      puts '******'
      puts 'BLAH BLAHB BLAH'
      update_payout(receiving_data)

      respond_to do |format|
        format.json {render json: {status: 200}}
      end 
    else
      respond_to do |format|
        format.json {render json: {status: 200}}
      end 
    end
  end


  def update_payout(receiving_data)
    tr_id = receiving_data['data']['object']['id']
    tr_status = receiving_data['data']['object']['status']
    tr_message = receiving_data['data']['object']['failure_message']
    tr_last4 = receiving_data['data']['object']['bank_account']['last4']

    puts "*****"
    puts "BLAHB LAHB LAH!!!"

    @payout = Payout.find_by_stripe_transfer_id(tr_id)

    #Update payout object depending on response from stripe
    @payout.status = tr_status
    message = "Bank Account Last 4: #{tr_last4}  || #{tr_status} => Return Message: #{tr_message}"
    @payout.message = message

    @payout.save

    #Notify user if payout failed
    if tr_status == 'failed'
      AdvloMailer.delay.payout_failed_email(@payout)
    end
    if tr_status == 'paid'
      #Notify host of the initiated payout
      AdvloMailer.delay.payout_completed_email(@payout)
    end
  end
  
end



