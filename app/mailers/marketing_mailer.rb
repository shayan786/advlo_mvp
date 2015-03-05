class MarketingMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  
  default from: "info@advlo.com"
  layout 'advlo_mail'

  # Marketing or less important emails
  marketing_smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME_MARKETING'],
    :password       => ENV['SENDGRID_PASSWORD_MARKETING'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }

  def deliver(mail = @mail)
    out = super
    @@smtp_settings = marketing_smtp_settings
    out
  end


  # ----------- MARKETING EMAILS --------------------------------------------------------------------------------------------------
  
  def market_share_your_adventure_host(host) 
    @user = host
    @adventures = @user.adventures

    mail(to: @user.email, subject: "[ADVLO] : Sharing your adventures") do |format|
      format.html { render layout: 'marketing_advlo_mail' }
      format.text
    end
  end

  def market_one_week_last_login_user(user)
    @user = user

    mail(to: @user.email, subject: "[ADVLO] : Month in Review") do |format|
      format.html { render layout: 'marketing_advlo_mail' }
      format.text
    end
  end

  def market_hawaii_move(user)
    @user = user

    mail(to: @user.email, subject: "[ADVLO] : Advlo's In Hawaii") do |format|
      format.html { render layout: 'marketing_advlo_mail' }
      format.text
    end
  end

  def market_new_feature_messages(user)
    @user = user

    mail(to: @user.email, subject: "[ADVLO] : Some big changes") do |format|
      format.html { render layout: 'marketing_advlo_mail' }
      format.text
    end
  end

  def market_embed_feature(user)
    @user = user

    mail(to: @user.email, subject: "[ADVLO] : New Embed Feature") do |format|
      format.html { render layout: 'marketing_advlo_mail' }
      format.text
    end
  end

  def market_nearby_adventures(user)
    @user = user

    if user.email_list == true
      if !user.is_guide
        # Get location through IP
        geocode_obj = Geocoder.search(user.current_sign_in_ip)

        lat = geocode_obj[0].data['latitude']
        long = geocode_obj[0].data['longitude']

        # Other option, if that traveler has specific the categories 'liked' find those then randomly select 3
        if user.category && user.category != ''
          user_pref_categories = user.category.split(',')

          category_sql_string = ''
          user_pref_categories.each_with_index do |cat,i|
            if (i==0)
              category_sql_string = "category LIKE '%#{cat}%'"
            elsif (i > 0)
              category_sql_string = category_sql_string + " OR category LIKE '%#{cat}%'"
            end
          end

          nearby_adventures = Adventure.near([lat,long],150).approved.limit(10).order('RANDOM()').where(category_sql_string).limit(3)

        else
          # Find nearby adventures 150 miles randomly
          nearby_adventures = Adventure.near([lat,long],300).approved.limit(10).order('RANDOM()').limit(3)
        end

        @nearby_adventures = nearby_adventures

        # If there any, then send the email
        if nearby_adventures.length > 0
          mail(to: @user.email, subject: "[ADVLO] : Adventures Near You") do |format|
            format.html { render layout: 'marketing_advlo_mail' }
            format.text
          end
        end
      end
    end
    
  end

  #--------------------- OUTREACH EMAILS -----------------------------------------



  def jon_market_host_outreach(email, reference=nil)
    @email = email
    @reference = reference

    mail(to: @email, from: 'support@advlo.com', subject: "Adventure Travel Marketplace", bcc: "advlo@pipedrivemail.com") do |format|
      format.html { render layout: 'simple_jon' }
      format.text
    end
  end

  def christopher_market_host_outreach(email, name, reference=nil)
    @email = email
    @reference = reference
    @name = name

    mail(to: @email, from: 'christopher@advlo.com', subject: "Adventure Marketplace") do |format|
      format.html { render layout: 'simple' }
      format.text
    end
  end

  def shayan_market_host_outreach(email, category = nil, location)
    @email = email
    @category = category
    @location = location

    mail(to: @email, from: 'shayan@advlo.com', subject: "Adventure Marketplace") do |format|
      format.html { render layout: 'simple_shayan' }
      format.text
    end
  end


  def surf_host_outreach(email, reference=nil)
    @reference = reference
    @email = email

    mail(to: @email, from: 'founders@advlo.com', subject: "Adventure Marketplace") do |format|
      format.html { render layout: 'simple' }
      format.text
    end
  end

  def market_publisher_outreach(email, reference)
    @reference = reference
    @email = email

    mail(to: @email, from: 'christopher@advlo.com',subject: "Adventure Local - partnership", cc: @cc, bcc: @bcc) do |format|
      format.html { render layout: 'simple' }
      format.text
    end
  end

  #----------------------- newsletter-signups ----------------------

  def newsletter_welcome_invite(email)
    @email = email

    # if @email.latitude != 0.0
    #   @adventures = Adventure.near([@email.latitude, @email.longitude],250).approved.limit(3).order('RANDOM()')
    # end

    @latest_blogs = Blogpost.where(state: "Published").order('created_at DESC').limit(2)

    # if !@adventures
    @adventures = Adventure.approved.where(featured: true).sample(2)
    # end

    mail(to: @email.email, subject: "[ADVLO] #{@email.category} - adventure") do |format|
      format.html { render layout: 'email_list_advlo_mail' }
      format.text
    end
  end
end

