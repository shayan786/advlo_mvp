class SitemapController < ApplicationController
  respond_to :xml
  layout false

  def index
    @adventures = Adventure.approved #we are generating url's for adventures
    @blogposts = Blogpost.where(state: "Published").order('created_at DESC')
  end
end