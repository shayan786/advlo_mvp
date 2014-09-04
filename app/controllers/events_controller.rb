class EventsController < ApplicationController

	def index
		# Show events that have no reservations
		@events = Event.where(adventure_id: params[:adventure_id])
		@adventure = Adventure.find_by_id(params[:adventure_id])

		start_q = Time.at(params[:start].to_time)
		end_q = Time.at(params[:end].to_time)

		@events_n = @events.where("start_time >= ? OR end_time <= ?", start_q, end_q)
		@events_j = @events_n.all.map{|e| {"id" => "#{e.id}", "title"=> @adventure.title, "allDay" => false, "start"=> e.start_time.to_time, "end"=> e.end_time.to_time}}

		respond_to do |format|
			format.json {render json: @events_j}
		end  

	end

	def create
		@adventure = Adventure.find(params[:adventure_id])
		@event = Event.new

		end_time_min = params[:start_time].to_time.advance(seconds: @adventure.dur_to_sec)
		@event = Event.create!(start_time: params[:start_time].to_time, end_time: end_time_min, adventure_id: params[:adventure_id], capacity: @adventure.cap_max)


		if @event.save
			respond_to do |format|
				format.json {render json: {"id"=> @event.id, "title"=>@adventure.title, "allDay" => false, "start"=> @event.start_time, "end"=> @event.end_time}}
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
			@event.update(start_time: params[:start].to_time, end_time: params[:end].to_time)

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