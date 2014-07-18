class PayoutsController < ApplicationController

  def index
    @payouts = Payout.all
  end
end