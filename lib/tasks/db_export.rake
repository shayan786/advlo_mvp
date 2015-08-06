# lib/tasks/db.rake
namespace :db do

  desc "Dumps the database to db/APP_NAME.dump"
  task :dump => :environment do
    cmd = nil
    with_config do |app, host, db|
      cmd = "pg_dump --host #{host} --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/#{app}.dump"
    end
    puts cmd
    exec cmd
  end

 
  private

  def with_config
    yield Rails.application.class.name.underscore,
      ActiveRecord::Base.connection_config[:host] || 'localhost',
      ActiveRecord::Base.connection_config[:database]
  end

end