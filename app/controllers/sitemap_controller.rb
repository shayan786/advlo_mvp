class SitemapController < ApplicationController
  respond_to :xml
  layout false

  def index
    @adventures = Adventure.approved #we are generating url's for adventures
  end
end