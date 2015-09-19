class MessagesController < ApplicationController

  def new
    # Create a new message
    body = params[:message][:body]
    body.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).each do |x|
      body.gsub! x, '...'
    end

    @message = Message.new(
        :conversation_id => params[:message][:conversation_id],
        :sender_id => params[:message][:sender_id],
        :body => body
      )

    @message.save

    @conversation = Conversation.find_by_id(@message.conversation_id)
    @conversation.updated_at = @message.created_at
    @conversation.save
    

    if @message.sender_id = @conversation.sender_id
      receiver = User.find_by_id(@conversation.receiver_id)
    else
      receiver = User.find_by_id(@conversation.sender_id)
    end


    # Send email to the receiver
    AdvloMailer.delay.new_message_email(@conversation, @message)


    respond_to do |format|
      format.js {render :action => 'new_message.js', :layout => false}
    end

  end

  def read
    message = Message.find_by_id(params[:id])

    message.read = true

    if message.save
      respond_to do |format|
        format.js {render json: {status: 200}}
      end
    end
  end

  def destroy

  end  

end