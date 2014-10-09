class MessagesController < ApplicationController

  def new
    # Create a new message
    @message = Message.new(
        :conversation_id => params[:message][:conversation_id],
        :sender_id => params[:message][:sender_id],
        :body => params[:message][:body]
      )

    @message.save

    # Send email to the receiver
    conversation = Conversation.find_by_id(@message.conversation_id)

    if @message.sender_id = conversation.sender_id
      receiver = User.find_by_id(conversation.receiver_id)
    else
      receiver = User.find_by_id(conversation.sender_id)
    end

    #AdvloMailer.delay....


    respond_to do |format|
      format.js {render :action => 'new_message.js', :layout => false}
    end

  end

  def destroy

  end  

end