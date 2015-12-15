require 'active_support/concern'

module TumblrClient
  extend ActiveSupport::Concern

  PAGE_SIZE = 20

  class_methods do
    def client
      Tumblr::Client.new
    end
  end

  class Error < StandardError; end
end
