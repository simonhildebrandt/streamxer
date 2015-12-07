class BlogsController < ApplicationController

  before_action :get_blog, only: [:show, :update]

  def index
    @blogs = current_user.blogs
    if params[:collection]
      @blogs = @blogs.in(collection_ids: params[:collection])
    end
    if params[:mode] == 'none'
      @blogs = @blogs.uncollected
    end
    @blogs = @blogs.sfw.limit(10)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    respond_to do |format|
      format.html { @posts = @blog.posts.newest.all }
      format.json
    end
  end

  def update
    @blog.update_attributes! blog_params
    render nothing: true
  end

  private

  def blog_params
    params.permit(:collection_ids => [])
  end

  def get_blog
    @blog = Blog.find_by(name: params[:id])
  end
end
