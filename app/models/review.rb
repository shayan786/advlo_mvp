class Review < ActiveRecord::Base
  belongs_to :adventure
  belongs_to :user


  def get_weighted_rating 
    @review = Review.find_by_id(self.id)

    adv_rating = @review.adv_rating.to_f
    host_rating = @review.host_rating.to_f

    
    # Simple weight of 60% Host and 40% Adventure (Host does matter more!)
    overall_rating = (0.6*host_rating + 0.4*adv_rating).round(1)

    return overall_rating
  end

end
