class EventsController < ApplicationController

	def index
		@events = Event.where(adventure_id: params[:adventure_id])

		start_q = Time.at(params[:start].to_i)
		end_q = Time.at(params[:end].to_i)

		@events_n = @events.where("start_time >= ? and end_time <= ?", start_q, end_q)
		@events_j = @events_n.all.map{|e| {"id" => "#{e.id}", "title"=>"IB", "allDay" => false, "start"=> e.start_time.to_time.iso8601, "end"=> e.end_time.to_time.iso8601}}

		respond_to do |format|
			format.json {render json: @events_j}
		end  

	end

	def create
		@event = Event.new
		@event = Event.create(event_params)

		if @event.save
			respond_to do |format|
				format.js {render "create.js", layout: false}
				format.json {render json: {"title"=>"IB", "allDay" => false, "start"=> @event.start_time.to_time.iso8601, "end"=> @event.end_time.to_time.iso8601}}
			end
		end
	end

	def update

	end

	def destroy
		@event = Event.find(params[:id])

		@event.destroy

		respond_to do |format|
			format.json {render json: {deleted: "true"}}
		end
	end

	private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def event_params
    params.permit(:start_time, :end_time, :adventure_id)
  end

end