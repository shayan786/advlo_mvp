#set :environment, 'development'
set :output, "#{path}/log/scheduler.log"


# To check if requested reservations are replied to within 48 hours by the host
every 10.minutes do
  runner "Reservation.run_request_time_check"
end

# To check if requested reservations are replied to within 48 hours by the host
# every 3.days do
#   rake "payouts:rake:task"
# end
