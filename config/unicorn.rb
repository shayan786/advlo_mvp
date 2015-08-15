# Set the current app's path for later reference. Rails.root isn't available at
# this point, so we have to point up a directory.
app_path = File.expand_path(File.dirname(__FILE__) + '/..')

# The number of worker processes you have here should equal the number of CPU
# cores your server has.
worker_processes (ENV['RAILS_ENV'] == 'production' ? 1 : 1)

# After the timeout is exhausted, the unicorn worker will be killed and a new
# one brought up in its place. Adjust this to your application's needs. The
# default timeout is 60. Anything under 3 seconds won't work properly.
timeout 300


# Load the app up before forking.
preload_app true

# Garbage collection settings.
GC.respond_to?(:copy_on_write_friendly=) &&
  GC.copy_on_write_friendly = true


# If using ActiveRecord, disconnect (from the database) before forking.
before_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

# After forking, restore your ActiveRecord connection.
after_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end