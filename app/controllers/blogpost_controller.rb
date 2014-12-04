class BlogpostController < ApplicationController
  before_filter :get_panel_content


  def new
    @blogpost = Blogpost.new
  end

  def create
    @blogpost = Blogpost.create(blogpost_params)
  end

  def show
    @blogpost = Blogpost.find_by(permalink: params[:permalink])
    @blogpost.view_count = ((@blogpost.view_count.nil?) ? 0 : @blogpost.view_count) + 1
    # @most_read_blogposts = Blogpost.published.order('view_count').reverse

    @related_adventures = Adventure.approved.where(featured: true).limit(6).order('CREATED_AT desc')

    @blogpost.save
  end

  def index
    @blogposts = Blogpost.order('created_at DESC').limit(7)
    @photos = Instagram.user_recent_media(847673197, {:count => 10})
    @recent_adventures = Adventure.approved.take(6)

    client = Twitter::REST::Client.new do |config|
      config.consumer_key = "p84FKXgsg1UjvK1x3UcxGptFJ"
      config.consumer_secret = "yjK1QDWSsD00O9YiERTPJlfeQ7fJDDzWOlJYj8gagR94yDyIMu"
    end
    
    @tweets = client.user_timeline('advlo_', count: 5)
  end

  private

    def blogpost_params
      params.require(:blogpost).permit(:title, :author, :body, :attachment, :video_url, :featured)
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
