Sidekiq.configure_server do |config|
  config.redis = { password: '' }
end

Sidekiq.configure_client do |config|
  config.redis = { password: '' }
end
