require 'active_support/concern'

module TumblrClient
  extend ActiveSupport::Concern

  class_methods do
    def client
      Tumblr::Client.new
    end
  end

  class Error < StandardError; end
end
