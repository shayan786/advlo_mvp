class StripeHooksController < ApplicationController
  protect_from_forgery :except => :receiver


  def receiver 
    receiving_data = JSON.parse request.body.read

    if receiving_data['type'] == "transfer.failed"
      update_payout(receiving_data)

      respond_to do |format|
        format.json {render json: {status: 200}}
      end 
    elsif receiving_data['type'] == "transfer.paid"
      update_payout(receiving_data)

      respond_to do |format|
        format.json {render json: {status: 200}}
      end 
    elsif receiving_data['type'] == "customer.subscription.deleted"
      update_subscription(receiving_data)

      respond_to do |format|
        format.json {render json: {status: 200}}
      end 

    elsif receiving_data['type'] == "invoice.payment_succeeded"
      sub_id = receiving_data['data']['object']['lines']['data'][0]['id']
      user = User.find_by_stripe_subscription_id(sub_id)
      AdvloMailer.send_monthly_subscription_email(user.id).deliver

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
    # Puts for logs
    puts '*************************'
    puts receiving_data
    puts '*************************'

    tr_id = receiving_data['data']['object']['id']
    tr_status = receiving_data['data']['object']['status']

    tr_message = receiving_data['data']['object']['failure_message']
    tr_last4 = receiving_data['data']['object']['bank_account']['last4']

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

  def update_subscription(receiving_data)
    sub_id = receiving_data['data']['object']['lines']['data'][0]['id']
    user = User.find_by_stripe_subscription_id(sub_id)
    
    user.adventures.each do |adv|
      adv.subscription_redirect_url = nil
      adv.save
    end

    user.stripe_subscription_id = nil

    user.save

    # Send Emails?
  end
  
end



