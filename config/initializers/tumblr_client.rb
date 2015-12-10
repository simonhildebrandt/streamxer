Tumblr.configure do |config|
  Rails.application.config_for(:tumblr).tap do |data|
    config.consumer_key = data['consumer_key']
    config.consumer_secret = data['consumer_secret']
  end
end
