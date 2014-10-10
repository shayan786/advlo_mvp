class ConversationsController < ApplicationController

  def new 
    # Create a new conversation
    conversation = Conversation.new(
        :adventure_id => params[:conversation][:adventure_id],
        :sender_id => params[:conversation][:user_id],
        :receiver_id => params[:conversation][:host_id],
        :subject => params[:conversation][:subject]
      )
    conversation.save

    # Create the initial message
    message = Message.new(
        :sender_id => params[:conversation][:user_id],
        :body => params[:message][:body],
        :conversation_id => conversation.id
      )
    message.save

    # Update the conversation updated at
    conversation.updated_at = message.created_at

    conversation.save

    # Email the host about the initial message
    AdvloMailer.delay.new_message_email(conversation, message)

    # Redirect to user's conversations
    redirect_to "/users/conversations", notice: "Your message has been sent."
  end

  def destroy

  end

end