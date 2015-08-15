Sidekiq.configure_server do |config|
  production:
    :concurrency: 3
end