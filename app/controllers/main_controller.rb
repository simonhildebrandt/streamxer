class MainController < ApplicationController
  skip_before_filter :require_logged_in, only: [:welcome]

  def index
  end

  def welcome
  end
end
