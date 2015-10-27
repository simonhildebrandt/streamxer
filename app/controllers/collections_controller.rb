class CollectionsController < ApplicationController
  def index
    @collections = current_user.collections
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
