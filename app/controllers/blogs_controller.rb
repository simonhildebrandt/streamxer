class BlogsController < ApplicationController

  before_action :get_blog, only: [:show]

  def index
    @blogs = current_user.blogs.all
  end

  def show
    @posts = @blog.posts.newest.all
  end

  private

  def get_blog
    @blog = Blog.find_by(name: params[:name])
  end
end
