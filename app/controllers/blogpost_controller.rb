class BlogpostController < ApplicationController
  before_filter :get_panel_content


  def new
    @blogpost = Blogpost.new
  end

  def create
    @blogpost = Blogpost.create(blogpost_params)
  end

  def show
    @blogposts = Blogpost.where(state: "Published").order('created_at DESC')
    @blogpost = Blogpost.find_by(permalink: params[:permalink])
    @blogpost.view_count = ((@blogpost.view_count.nil?) ? 0 : @blogpost.view_count) + 1
    
    @blog_images = @blogpost.blog_images.order(:order).reverse

    get_featured_locations(['Costa Rica','United States','Vietnam','Ecuador','Nicaragua'])
    @adventures = Adventure.approved.sample(3)

    @blogpost.save
  end

  def get_featured_locations(places)
    @locations = []
    places.each do |a|
      if HeroImage.where(region: a).count > 0
        @locations << HeroImage.where(region: a).last 
      end
    end

    return @locations
  end

  def index
    @blogposts = Blogpost.where(state: "Published").order('created_at DESC')
    @adventures = Adventure.approved.sample(6)
    get_featured_locations(['Costa Rica','United States','Vietnam','Ecuador','Nicaragua'])

    # @photos = Instagram.user_recent_media(847673197, {:count => 5})

    # client = Twitter::REST::Client.new do |config|
    #   config.consumer_key = "p84FKXgsg1UjvK1x3UcxGptFJ"
    #   config.consumer_secret = "yjK1QDWSsD00O9YiERTPJlfeQ7fJDDzWOlJYj8gagR94yDyIMu"
    # end
    # @tweets = client.user_timeline('advlo_', count: 4)
  end

  private

    def blogpost_params
      params.require(:blogpost).permit(:title, :author, :body, :attachment, :video_url, :featured, :blog_images)
    end

    def get_panel_content
      # @most_read_blogposts = Blogpost.published.order('view_count').reverse
      # @featured_posts = Blogpost.where(featured: true).order("created_at DESC").limit(5)
      # client = Twitter::REST::Client.new do |config|
      #   config.consumer_key = "p84FKXgsg1UjvK1x3UcxGptFJ"
      #   config.consumer_secret = "yjK1QDWSsD00O9YiERTPJlfeQ7fJDDzWOlJYj8gagR94yDyIMu"
      # end

      # @tweets = client.user_timeline('gemgento', count: 5)
    end
end
