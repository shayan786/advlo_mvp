Rails.application.configure do

  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = true
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.assets.version = '1.0'
  # config.force_ssl = true
  # Set to :debug to see everything in the log.
  config.log_level = :info
  # config.log_tags = [ :subdomain, :uuid ]
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)
  # config.cache_store = :mem_cache_store
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  # config.assets.precompile += %w( search.js )
  config.assets.precompile += %w( .svg .eot .woff .ttf )
  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
  

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: 'advlo.com' }
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false

  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => ENV['S3_BUCKET_NAME'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }
  }
  
end
