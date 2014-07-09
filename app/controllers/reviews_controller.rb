class ReviewsController < ApplicationController

  def index
   
    respond_to do |format|
      format.json {render json: @events_j}
    end  
  end

  def create
    @review = Review.create!(review_params)

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
    @review = Review.find(params[:adventure_id])
    @review.update(review_params)

    respond_to do |format|

    end
  end

  def destroy
    @review = Review.find(params[:adventure_id])
    @review.destroy

    respond_to do |format|

    end
  end

  private
  def review_params
    params.required(:review).permit(:body, :adventure_id, :user_id, :host_id)
  end
end