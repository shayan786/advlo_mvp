class PayoutsController < ApplicationController

  def index
    @payouts = Payout.all
  end

  def create

  end

end