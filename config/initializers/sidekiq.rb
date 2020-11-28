Sidekiq.configure_server do |_config|
  ActiveRecord::Base.configurations[Rails.env.to_s]['pool'] = 30
  _config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/1') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/1') }
end

if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV["REDISTOGO_URL"] }
  end
  Sidekiq.configure_client do |config|
    config.redis = { url: ENV["REDISTOGO_URL"] }
  end
end
