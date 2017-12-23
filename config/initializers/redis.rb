Sidekiq.configure_server do |config|
  config.redis = { password: 'my_qwerty_password' }
end

Sidekiq.configure_client do |config|
  config.redis = { password: 'my_qwerty_password' }
end
