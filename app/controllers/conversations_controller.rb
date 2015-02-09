class ConversationsController < ApplicationController

  # Start a conversation without being a registered user
  # 1. Check to see if current email already exists?
  # 2. If YES => Sign in please
  # 3. If NO => Create new user with just email with intentions to add password
  #             in order to reply
  # 4. Send emails

  def new_user
    user_email = params[:email]

    if User.find_by_email(user_email)
      redirect_to '/users/sign_in', notice: "Email already exists, please sign-in."
    else
      user = User.create(:email => user_email)


      conversation = Conversation.create(
          :sender_id => user.id,
          :receiver_id => params[:conversation][:host_id],
          :subject => params[:conversation][:subject]
        )

      message = Message.create(
          :sender_id => user.id,
          :body => params[:message][:body],
          :conversation_id => conversation.id
        )

      conversation.updated_at = message.created_at
      conversation.save

      # Email the host about the initial message
      AdvloMailer.delay.new_message_email(conversation, message)
    end
  end

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