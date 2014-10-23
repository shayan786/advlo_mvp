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
      update_user_adventure(receiving_data)

      respond_to do |format|
        format.json {render json: {status: 200}}
      end 

    elsif receiving_data['type'] == "invoice.payment_succeeded"
      puts "receiving_data=========>#{receiving_data}"

      sub_id = receiving_data['data']['object']['lines']['data'][0]['id']
      puts "SUB - ID =========>#{receiving_data['data']['object']['lines']['data'][0]['id']}"
      
      user_adventure = UserAdventure.find_by_stripe_subscription_id(sub_id)
      puts "user_adventure =========>#{user_adventure}"

      AdvloMailer.send_monthly_subscription_email(user_adventure.user_id, user_adventure.adventure_id).deliver

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

  def update_user_adventure(receiving_data)
    sub_id = receiving_data['data']['object']['id']
    user_adventure = UserAdventure.find_by_stripe_subscription_id(sub_id)
    adventure = Adventure.find(user_adventure.adventure_id)

    user_adventure.charge_type = nil
    user_adventure.stripe_subscription_id = nil
    adventure.redirect_url = nil

    user_adventure.save
    adventure.save

    # Send Emails?
  end
  
end



