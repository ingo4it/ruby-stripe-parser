require 'sidekiq/web'

if Rails.env == 'development'
  
  Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://localhost:6379/12' }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://localhost:6379/12' }
  end

else

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'], password: ENV['REDIS_PASSWORD'] }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'], password: ENV['REDIS_PASSWORD'] }
  end

end

Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
