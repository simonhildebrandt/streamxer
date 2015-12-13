require 'sidekiq/api'

class MainController < ApplicationController
  skip_before_filter :require_logged_in, only: [:welcome, :health]

  def index
  end

  def welcome
  end

  def health
    render text: "#{User.count} users, #{Blog.count} blogs, #{Post.count} posts, #{Sidekiq::Queue.new.size} jobs, #{Blog.syncing.count} blogs syncing."
  end
end
