class EmailsController < ApplicationController

  def create
    puts "request ===> #{request}"
    puts "ip / request.location ===> #{request.location}"
    
    ip = request.location
    @email = Email.create(email: params[:email][:address])
    @email.category = params[:email][:category]
    @email.latitude = ip.latitude if ip.latitude
    @email.longitude = ip.longitude if ip.longitude
    @email.save
    
    if @email.save
      MarketingEmail.create(email: @email.email, title: "#{@email.email} => #{@email.category} signup")
      AdvloMailer.newsletter_welcome_invite(@email).deliver

      respond_to do |format|
        format.js { render action: 'email_list.js', layout: false}
      end
    else
      respond_to do |format|
        format.js { render action: 'email_list_fail.js', layout: false}
      end
    end
  end


  def unsubscribe
    @email = Email.find(params[:id])

    respond_to do |format|
      format.html {redirect_to '/', notice: %Q( Unsubscribe from all emails ?  <a href="/email-list/unsubscriber/#{@email.id}">Yes</a> / <a href="/about">No</a> )  }
    end
  end

  def unsubscribe_email_list

    if email = Email.find(params[:id])
      email.destroy

      respond_to do |format|
        format.html {redirect_to '/', notice: "Its ok. You can <a href='/users/edit'>come back</a> if you want."}
      end
    else
      render text: 'Invalid link.'
    end
  end
end