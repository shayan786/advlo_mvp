class EventsController < ApplicationController

	def index
		# Show events that have no reservations
		@events = Event.where(adventure_id: params[:adventure_id])
		@adventure = Adventure.find_by_id(params[:adventure_id])

		@events_open = @events.where.not(:id => Reservation.select(:event_id).uniq)

		start_q = Time.at(params[:start].to_i)
		end_q = Time.at(params[:end].to_i)

		@events_n = @events_open.where("start_time >= ? and end_time <= ?", start_q, end_q)
		@events_j = @events_n.all.map{|e| {"id" => "#{e.id}", "title"=> @adventure.title, "allDay" => false, "start"=> e.start_time.to_time.iso8601, "end"=> e.end_time.to_time.iso8601}}

		puts "********"
		puts @events_j
		puts "********"

		respond_to do |format|
			format.json {render json: @events_j}
		end  

	end

	def reserved
		@events_all = Event.where(adventure_id: params[:adventure_id])
		@adventure = Adventure.find_by_id(params[:adventure_id])

		@events_reserved = @events_all.joins(:reservations)

		start_q = Time.at(params[:start].to_i)
		end_q = Time.at(params[:end].to_i)

		@events_n = @events_reserved.where("start_time >= ? and end_time <= ?", start_q, end_q)
		@events_j = @events_n.all.map{|e| {"id" => "#{e.id}", "title"=> @adventure.title, "allDay" => false, "start"=> e.start_time.to_time.iso8601, "end"=> e.end_time.to_time.iso8601}}

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

		# Cannot update an event that has reservations
		if @event.reservations.exists?
			respond_to do |format|
				format.json {render json: {error: "true", message: "Cannot update this event"}}
			end
		else
			@event.update(start_time: params[:start], end_time: params[:end])

			respond_to do |format|
				format.json {render json: {updated: "true"}}
			end
		end

	end

	def destroy
		@event = Event.find(params[:id])

		# Cannot delete an event that has reservations
		if @event.reservations.exists?
			format.json {render json: {error: "true", message: "Cannot delete this event"}}
		else
			@event.destroy

			respond_to do |format|
				format.json {render json: {deleted: "true"}}
			end
		end
	end

  private
  
  def event_params
    params.permit(:start_time, :end_time, :adventure_id, :capacity)
  end
end