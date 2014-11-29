ActiveAdmin.register Blogpost do

  index do
    column :title
    column :author
    column 'Preview' do |post|
      link_to 'Preview', preview_admin_blogpost_path(post), target: 'blank'
    end
    actions
  end

  member_action :preview, method: :get do
    # @active_section = 'blog'
    # @blogpost = Blogpost.find(params[:id])
    # @most_read_blogposts = Blogpost.published.order('view_count').reverse
    # @featured_posts = Blogpost.where(featured: true).order("created_at DESC").limit(5)
    # client = Twitter::REST::Client.new do |config|
    #   config.consumer_key = "p84FKXgsg1UjvK1x3UcxGptFJ"
    #   config.consumer_secret = "yjK1QDWSsD00O9YiERTPJlfeQ7fJDDzWOlJYj8gagR94yDyIMu"
    # end

    # @tweets = client.user_timeline('gemgento', count: 5)

    render 'blogpost/show.haml'
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :title
      f.input :author
      f.input :permalink
      f.input :state, include_blank: false, as: :select, collection: Blogpost::STATE
      f.input :body, as: :text
      f.input :video_url, placeholder: 'http://www.youtube.com/watch?v=F7RzbUX2GjM || https://vimeo.com/48024809'
      f.input :attachment, as: :file
    end
    f.actions
  end


  controller do
    def permitted_params
      params.permit!
    end
  end
end
