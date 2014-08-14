class StripeHooksController < ApplicationController
  require 'json'

  def receiver 

    receiving_data = JSON.parse request.body.read

    puts data_json['data']['object']

  end
  

end

