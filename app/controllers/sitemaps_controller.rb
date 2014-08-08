class SitemapsController < ApplicationController
  def show
    @adventures = Adventure.approved #we are generating url's for adventures
    respond_to do |format|
     format.xml
    end
  end
end