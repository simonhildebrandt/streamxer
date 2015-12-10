Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  Rails.application.config_for(:tumblr).tap do |data|
    provider :tumblr, data['consumer_key'], data['consumer_secret']
  end
end
