class ReviewsController < ApplicationController

  def index
   
    respond_to do |format|
      format.json {render json: @events_j}
    end  
  end

  def create
    @review = Review.create!(review_params)
    adventure = Adventure.find_by_id(@review.adventure_id)

    adventure.calculate_rating

    if @review.save
      respond_to do |format|
        format.js {render "create.js", layout: false}
      end
    else
      respond_to do |format|
        format.js {render "error.js", layout: false}
      end
    end
  end

  def update
    @review = Review.find_by_id(params[:id])
    @review.update(review_params)

    if @review.save
      respond_to do |format|
        format.js {render "update.js", layout: false}
      end
    else
      respond_to do |format|
        format.js {render "error.js", layout: false}
      end
    end
  end

  def destroy
    @review = Review.find_by_id(params[:id])
    @review.destroy

    if @review.save
      respond_to do |format|
        format.js {render "create.js", layout: false}
      end
    else
      respond_to do |format|
        format.js {render "error.js", layout: false}
      end
    end
  end

  private
  def review_params
    params.required(:review).permit(:body, :adventure_id, :user_id, :host_id, :id, :adv_rating, :host_rating)
  end
end