class MainController < ApplicationController
  skip_before_filter :require_logged_in, only: [:welcome, :health]

  def index
  end

  def welcome
  end

  def health
    render text: User.count
  end
end
