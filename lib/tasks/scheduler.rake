desc "This task is called by the Heroku scheduler add-on"

task :run_request_time_check => :environment do
  puts "RUNNING RESERVATIONS REQUEST CHECK..."
  Reservation.run_request_time_check
  puts "COMPLETED RESERVATIONS REQUEST CHECK..."
end