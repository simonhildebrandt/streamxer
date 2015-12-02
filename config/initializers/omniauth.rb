Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :tumblr, ENV['TUMBLR_KEY'], ENV['TUMBLR_SECRET']
end
