class CollectionsController < ApplicationController
  def index
    if params[:search]
      @collections = current_user.collections.search_by_name(params[:search]).to_a
    else
      @collections = current_user.collections
    end
  end

  def show
  end

  def edit
    @blogs = current_user.following
  end

  def create
  end

  def update
  end

  def destroy
  end
end
