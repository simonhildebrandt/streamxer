class BlogsController < ApplicationController
  def index
    @blogs = current_user.blogs.all
  end
end
