class AdventuresController < ApplicationController
  include ApplicationHelper

  def index
    if params[:region]
      region = params[:region]
      filter_index('region'.to_sym,region)

    elsif params[:country]
      country = params[:country]
      filter_index('country'.to_sym,country)

    elsif params[:city]
      city = params[:city]
      filter_index('city'.to_sym,city)
      
    elsif params[:state]
      state = params[:state]
      filter_index('state'.to_sym,state)
    else
      @adventures = Adventure.all.approved.limit(17).order('created_at DESC')
      @hero_image = HeroImage.where(region: "all").first
    end
  end


  def filter_index(type, position)
    region = position.gsub('-',' ')
    get_adventures(type,region)
    get_hero(region)
    @location = region.downcase
    if type == :state
      @filter_location = 'United States'
    else
      @filter_location = region
    end
  end

  def get_adventures(type, location)
    @adventures = Adventure.where(type => location).approved.order('created_at DESC')
  end

  def get_hero(location)
    @hero_image = HeroImage.where(region: location).last || HeroImage.where(region: 'all').first || HeroImage.last
    #HeroImage.where(region: Adventure.where("country LIKE ?", "%#{location}%").first).first.region || 
  end

  def show
    @adventure = Adventure.find_by_slug(params[:id])
    if @adventure.published == true && @adventure.approved == true
      adventure_show_variables
    elsif @adventure.users.first == current_user && @adventure.published == true
      adventure_show_variables
      flash[:notice] = "PENDING APPROVAL: We’ll notify you when it goes live"
    elsif @adventure.users.first == current_user && @adventure.published == nil || @adventure.published == false || (current_user ? check_if_advlo(current_user) : false)
      adventure_show_variables
      flash[:notice] = "PREVIEW MODE: Publish when ready"
    else  
      render '/error_404'
    end

  rescue Exception => e
    redirect_to '/*'
  end

  def adventure_show_variables
    @current_guide = @adventure.users.first
    @review = Review.new
    @adventure_reviews = Review.where(adventure_id: @adventure.id).order('created_at DESC')
    @itineraries = Itinerary.where(adventure_id: @adventure.id)

    @all_adventure_events = @adventure.events.where("capacity > 0 AND start_time > ?", Time.now.utc.advance(days: +1)).sort_by{|a| a.start_time}
    # @limited_adventure_events = @adventure.events.where("capacity > 0 AND start_time > ?", Time.now.advance(days: +1)).sort_by{|a| a.start_time}.take(5)

    related = []

    cats = @adventure.category.split(',')
    count = 0
    if cats.length > 1 && count < 0
      cats.each do |cat|
        count += 1
        related << Adventure.approved.where('category LIKE ?',"%#{cat}%").first
      end
    else
      related << Adventure.approved.where('category LIKE ?',"%#{@adventure.category}%").limit(1) 
    end
    if @adventure.nearbys(50)
      @adventure.nearbys(50).limit(3).each do |adv|
        related <<  adv if adv.approved && adv.published
      end
    end
    related = related.flatten.uniq
    related = related - [@adventure]
    @related = related.take(4)
    @reservation = Reservation.new
  end

  def filter
    region_type = params[:region_type]
    location_array = params[:region].gsub('-',' ').split(',')
    region_one_up = params[:region_one_up].gsub('-',' ')
    category_param = params[:category].gsub(',',' ').downcase
    category_array = category_param.split('-')
    sort_by = params[:sort_by]

    case region_type
    when "continent"
      adventures_region = Adventure.approved
      available_categories = [];

      location_sql_string = ''
      location_array.each_with_index do |loc,i|
        if (i==0)
          location_sql_string = "region LIKE '%#{loc}%'"
        elsif (i > 0)
          location_sql_string = location_sql_string + " OR region LIKE '%#{loc}%'"
        end
      end

    when "country"
      adventures_region = Adventure.approved.where(region: region_one_up)

      location_sql_string = ''
      location_array.each_with_index do |loc,i|
        if (i==0)
          location_sql_string = "country LIKE '%#{loc}%'"
        elsif (i > 0)
          location_sql_string = location_sql_string + " OR country LIKE '%#{loc}%'"
        end
      end
    when "city"
      adventures_region = Adventure.approved.where(country: region_one_up)

      location_sql_string = ''
      location_array.each_with_index do |loc,i|
        if (i==0)
          location_sql_string = "city LIKE '%#{loc}%'"
        elsif (i > 0)
          location_sql_string = location_sql_string + " OR city LIKE '%#{loc}%'"
        end
      end
    when "state"
      if params[:state].present?
        adventures_region = Adventure.approved.where(country: region_one_up).where(state: params[:state])
      else
        adventures_region = Adventure.approved.where(country: region_one_up)
      end

      location_sql_string = ''
      location_array.each_with_index do |loc,i|
        if (i==0)
          location_sql_string = "city LIKE '%#{loc}%'"
        elsif (i > 0)
          location_sql_string = location_sql_string + " OR city LIKE '%#{loc}%'"
        end
      end
    else

      adventures_region = Adventure.approved.where(city: region_one_up)
    end


    category_sql_string = ''
    category_array.each_with_index do |cat,i|
      if (i==0)
        category_sql_string = "category LIKE '%#{cat}%'"
      elsif (i > 0)
        category_sql_string = category_sql_string + " OR category LIKE '%#{cat}%'"
      end
    end
    
    case sort_by
    when 'none'
      # Apply category and location logic
      if category_param == 'all' && location_array[0] == "all"
        @adventures = adventures_region.order("rating DESC")
      elsif category_param == 'all' && location_array[0] != "all"
        @adventures = adventures_region.where(location_sql_string)
      elsif category_param != 'all' && location_array[0] == "all"
        @adventures = adventures_region.where(category_sql_string)
      else
        @adventures = adventures_region.where(category_sql_string).where(location_sql_string)
      end
    when 'price'
      # Apply sorting and category and location logic
      if category_param == 'all' && location_array[0] == "all"
        @adventures = adventures_region.order("#{sort_by} ASC")
      elsif category_param == 'all' && location_array[0] != "all"
        @adventures = adventures_region.where(location_sql_string).order("#{sort_by} ASC")
      elsif category_param != 'all' && location_array[0] == "all"
        @adventures = adventures_region.where(category_sql_string).order("#{sort_by} ASC")
      else
        @adventures = adventures_region.where(category_sql_string).where(location_sql_string).order("#{sort_by} ASC")
      end
    else
      # Apply sorting and  category and location logic
      if category_param == 'all' && location_array[0] == "all"
        @adventures = adventures_region.order("#{sort_by} DESC")
      elsif category_param == 'all' && location_array[0] != "all"
        @adventures = adventures_region.where(location_sql_string).order("#{sort_by} DESC")
      elsif category_param != 'all' && location_array[0] == "all"
        @adventures = adventures_region.where(category_sql_string).order("#{sort_by} DESC")
      else  
        @adventures = adventures_region.where(category_sql_string).where(location_sql_string).order("#{sort_by} DESC")
      end
    end

    respond_to do |format|
      format.js {render :action => '/adventure_filter', :layout => false }
    end
  end
  
  # info page for creating a new adventure
  def hosting_info
    @adventures = [] 
    @adventures << Adventure.find_by_slug('speedflying-basic-pilot')
    @adventures << Adventure.find_by_slug('private-surf-lessons')
    @adventures << Adventure.find_by_slug('the-pearl-islands-adventure')

    if params[:invite] == 'partner'
      @referrer = User.find_by_email('founders@advlo.com')
    elsif params[:invite] == 'hostel'
      @referrer = User.find_by_email('christopher@advlo.com')
    end

    @hero_image = HeroImage.where(region: 'info').first
  end

  def adventure_info
    render :layout => 'adventure_info'

  end

  # info page for requesting a certain adventure
  def request_info
    @hero_image = HeroImage.where(region: 'request').first
  end

  
  # Request Adventure
  def requests 
    if params[:honeypot] == '' || params[:honeypot] == nil
      @request = Request.create!(request_params)
      @request.category = params[:request_category] ? params[:request_category].join(',') : 'No category selected'

      if @request.save
        # Mail the requester
        AdvloMailer.delay.request_adventure_email(@request, @request.email)
        AdvloMailer.delay.request_adventure_email(@request, 'info@advlo.com')

        respond_to do |format|
          format.js {render "request.js", layout: false}
        end
      end
    else
      redirect_to :back
    end
  end

  #------------------------HOST LOGIC START----------------------------

  # Method to handle hosting/creating an adventure logic as follows:
  # 1) User is not registered or logged in (i.e. no sessions exists) 
  #     => redirect to register / sign in
  # 2) User is logged in but is not an authorized guide i.e is missing vital information in their profile to be a host
  #     => redirect to edit profile with with required info.
  # 3) User is logged in and profile is setup to host but has never hosted before
  #     => redirect to create an adventure info. page
  # 4) User is logged in and profile is setup to host and has hosted before
  #     => redirect to create a new adventure form

  def create_prefill
    if !user_signed_in?
      if request.path == '/adventures/info'
        redirect_to '/adventures/info'
      else
        redirect_to '/users/sign_up'
      end
    elsif user_signed_in? && !current_user.is_guide?(current_user.id)
      redirect_to '/users/edit', notice: "Complete your profile to upload an adventure"
    else 
      redirect_to '/adventures/new'
    end

  end

  def new
    #add another check...before actually showing the form
    if !user_signed_in? || (user_signed_in? && !current_user.is_guide?(current_user.id))
      redirect_to '/adventures/create_prefill', notice: "Complete your profile to upload an adventure"
    end

    @adventure = Adventure.new
  end

  #Show the create an Adventure Form and create a new entry for an adventure
  def create
    #add another check...before actually showing the form
    if !user_signed_in? || (user_signed_in? && !current_user.is_guide?(current_user.id))
      redirect_to '/adventures/create_prefill', notice: "Complete your profile to upload an adventure"
    end

    # Hook for banner image upload
    if params[:adventure][:attachment] 

      puts "#{params[:adventure][:attachment]} => params[:adventure][:attachment] "
      @adventure = Adventure.new

      @adventure.attachment = params[:adventure][:attachment]
      @adventure.save

      session[:adventure_id] = @adventure.id

      respond_to do |format|
        format.js {render "adventure_image_upload.js", layout: false}
      end

    elsif params[:adventure_id]

      @adventure = Adventure.find_by_id(params[:adventure_id])
      @adventure.update(adventure_params)

      @adventure.category = params[:category].join(',')

      if @adventure.save
        #associate that adventure with that host
        @useradventure = @adventure.user_adventures.build(user_id: current_user.id, adventure_id: @adventure.id)
        @useradventure.save

        @adventure.set_host_name
        @adventure.save

        # For updating the region
        continent = get_continent(params[:adventure][:region])
        @adventure.update(region: continent)

        redirect_to "/adventure_steps/photos"
      else
        render :new
      end
    end
  end

  #------------------------HOST LOGIC END-----------------------------


  #------------------------SEARCHING METHODS START--------------------
  def find

  end

  # Adventures Filter
  def find_adventure_filter
    adventures_id_array = params[:adventure_ids]
    price_sort_by = params[:price_sort_by]
    price_type = params[:price_type]

    # Update Flag for JS
    if params[:flag]
      @flag = true
    end

    adv_ids_sql_string = ''
    adventures_id_array.each_with_index do |adv_id,i|
      if (i==0)
        adv_ids_sql_string = "id = '#{adv_id}'"
      elsif (i > 0)
        adv_ids_sql_string += " OR id = '#{adv_id}'"
      end
    end

    @adventures = Adventure.where(adv_ids_sql_string)

    if price_sort_by == "NONE"
      category_sql_string = ''
      if params[:categories].kind_of?(Array)
        category_array = params[:categories]

        category_array.each_with_index do |cat,i|
          if (i==0)
            category_sql_string = "category LIKE '%#{cat}%'"
          elsif (i > 0)
            category_sql_string += " OR category LIKE '%#{cat}%'"
          end
        end

        @adventures = @adventures.where(category_sql_string)
      end

      if price_type != "NONE"
        @adventures = @adventures.where(price_type: "#{price_type}")
      end

    else 
      @adventures = @adventures.order("price #{price_sort_by}")

      category_sql_string = ''
      if params[:categories].kind_of?(Array)
        category_array = params[:categories]

        category_array.each_with_index do |cat,i|
          if (i==0)
            category_sql_string = "category LIKE '%#{cat}%'"
          elsif (i > 0)
            category_sql_string += " OR category LIKE '%#{cat}%'"
          end
        end

        @adventures = @adventures.where(category_sql_string)
      end

      if price_type != "NONE"
        @adventures = @adventures.where(price_type: "#{price_type}")
      end

    end

    respond_to do |format|
      format.js {render "find_adventure_filter.js", layout: false}
    end
  end

  def find_local_filter 
    # Update Flag for JS
    if params[:flag]
      @flag = true
    end

    user_ids_array = params[:user_ids]

    user_ids_sql_string = ''
    user_ids_array.each_with_index do |user_id,i|
      if (i==0)
        user_ids_sql_string = "id = '#{user_id}'"
      elsif (i > 0)
        user_ids_sql_string += " OR id = '#{user_id}'"
      end
    end

    @locals = User.where(user_ids_sql_string)
    locals_filtered_array = []

    if params[:categories].kind_of?(Array)
      @locals.each do |local|
        local.adventures.each do |adv|
          params[:categories].each do |cat|
            if adv.category.include?(cat)
              locals_filtered_array << local.id
              break
            end
          end
        end
      end

      locals_filtered_array = locals_filtered_array.uniq
    
      filtered_user_ids_sql_string = ''
      locals_filtered_array.each_with_index do |local_filtered_id, i|
        if (i==0)
          filtered_user_ids_sql_string = "id = '#{local_filtered_id}'"
        elsif (i > 0)
          filtered_user_ids_sql_string += " OR id = '#{local_filtered_id}'"
        end
      end

      @locals = User.where(filtered_user_ids_sql_string).sort_by{|local| local.name.downcase}
    end

    respond_to do |format|
      format.js {render "find_local_filter.js", layout: false}
    end
  end

  def find_by_location
    @location = params[:location]

    # Get geocode obj
    geocode_obj = Geocoder.search(@location)

    # SEARCH LOGIC:
    # 1: Is it a continent ()
    # 2: Is it a country ()
    # 3: Is it a state, US ONLY ()
    # 4: Is it a city ()
    # 5: Default use nearby 200 miles
    # 6: Return locals?

    geocode_type = geocode_obj[0].data['address_components'][0]['types'][0]

    case geocode_type
    when "continent"
      @adventures = Adventure.approved.where(region: @location).order('RANDOM()')

    when "colloquial_area"
      @adventures = Adventure.approved.where(region: @location).order('RANDOM()')

    when "country"
      country = geocode_obj[0].data['address_components'][0]['long_name']
      @adventures = Adventure.approved.where(country: country).order('RANDOM()')

    #State
    when "administrative_area_level_1"
      # Check to see if in the US
      if geocode_obj[0].data['address_components'][1]['short_name'] == "US"
        state = geocode_obj[0].data['address_components'][0]['long_name']
        @adventures = Adventure.approved.where(state: state)
      else
        @adventures = Adventure.approved.near(@location,200).order('RANDOM()')
      end

    #City
    when "locality"
      city = geocode_obj[0].data['address_components'][0]['long_name']
      country = geocode_obj[0].data['address_components'][2]['long_name']

      city_adv_count = Adventure.approved.where(city: city).length

      # Make sure there are atleast 3 & special cases 
      if country == "Costa Rica" || country == "Ecuador"
        @adventures = Adventure.approved.where(country: country).order('RANDOM()')
      elsif city_adv_count > 2 
        @adventures = Adventure.approved.where(city: city).order('RANDOM()')
      else
        @adventures = Adventure.approved.near(@location.to_s,200).order('RANDOM()')
      end

    else
      @adventures = Adventure.approved.near(@location,200).order('RANDOM()')
    end

    filter_categories = []
    @adventures.each do |adv|
      adv.category.split(",").each do |cat|
        filter_categories << cat
      end
    end

    @filter_categories = filter_categories.uniq.sort_by{|cat| cat.downcase}

    if params[:locals] == "true"
      user_ids_sql_string = ''
      @adventures.each_with_index do |adv,i|
        if (i==0)
          user_ids_sql_string = "id = '#{adv.users.first.id}'"
        elsif (i > 0)
          user_ids_sql_string = user_ids_sql_string + " OR id = '#{adv.users.first.id}'"
        end
      end

      @locals = User.where(user_ids_sql_string).sort_by{|local| local.name.downcase}

      # For filter, only display categories that are displayed under all
      filter_categories = []

      @locals.each do |local|
        local.get_host_adventure_categories.each do |cat|
          filter_categories << cat
        end
      end

      @filter_categories = filter_categories.uniq.sort_by{|cat| cat.downcase}
    end

    respond_to do |format|
      format.js {render "find_by_location.js", layout: false}
    end
  end

  def find_by_category
    category_array = params[:category]
    @categories = params[:category]

    category_sql_string = ''
    category_array.each_with_index do |cat,i|
      if (i==0)
        category_sql_string = "category LIKE '%#{cat}%'"
      elsif (i > 0)
        category_sql_string = category_sql_string + " OR category LIKE '%#{cat}%'"
      end
    end

    @adventures = Adventure.approved.where(category_sql_string).order('RANDOM()')

    if params[:locals] == "true"
      user_ids_sql_string = ''
      @adventures.each_with_index do |adv,i|
        if (i==0)
          user_ids_sql_string = "id = '#{adv.users.first.id}'"
        elsif (i > 0)
          user_ids_sql_string = user_ids_sql_string + " OR id = '#{adv.users.first.id}'"
        end
      end

      @locals = User.where(user_ids_sql_string).sort_by{|local| local.name.downcase}
    end

    respond_to do |format|
      format.js {render "find_by_activities.js", layout: false}
    end

  end

  #------------------------SEARCHING METHODS END----------------------  


  def destroy 
    @adventure = Adventure.find_by_id(params[:id])

    @adventure.destroy

    respond_to do |format|
      format.js {render "delete_adventure.js", layout: false}
    end
  end

  private

  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def adventure_params
    params.required(:adventure).permit(:title, :subtitle, :attachment, :region, :location, :city, :summary, :cap_min, :cap_max, :price, :price_type, :duration_num, :duration_type, :other_notes, :adventure_gallery_images, :images, :published, :region, :video_url, :category => [])
  end

  def request_params
    params.required(:request).permit(:user_id, :description, :email, :location, :dates, :budget)
  end

end

