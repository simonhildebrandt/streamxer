Rails.application.config_for(:redis).tap do |data|
  Sidekiq.configure_server do |config|
    config.redis = { url: data['uri'] }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: data['uri']  }
  end
end
