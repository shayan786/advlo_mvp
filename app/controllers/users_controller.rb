class UsersController < ApplicationController

  def index
    @user = User.all
  end

  def show
    @user = User.find(params[:id])

    @user_languages = @user.language.split(',')
    @user_skillsets = @user.skillset.split(',')
  end

end

