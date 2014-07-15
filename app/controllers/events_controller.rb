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
		@adventure = Adventure.find(params[:adventure_id])
		@event = Event.new

		end_time_min = params[:start_time].to_time.advance(seconds: @adventure.dur_to_sec)
		@event = Event.create!(start_time: params[:start_time], end_time: end_time_min, adventure_id: params[:adventure_id], capacity: @adventure.cap_max)

		if @event.save
			respond_to do |format|
				format.js {render "create.js", layout: false}
				format.json {render json: {"id"=> @event.id, "title"=>@adventure.title, "allDay" => false, "start"=> @event.start_time.to_time.iso8601, "end"=> end_time_min.to_time.iso8601}}
			end
		end
	end

	def update
		@event = Event.find(params[:id])

		@event.update(start_time: params[:start], end_time: params[:end])

		respond_to do |format|
			format.json {render json: {updated: "true"}}
		end
	end

	def destroy
		@event = Event.find(params[:id])

		@event.destroy

		respond_to do |format|
			format.json {render json: {deleted: "true"}}
		end
	end

  private
  
  def event_params
    params.permit(:start_time, :end_time, :adventure_id, :capacity)
  end
end