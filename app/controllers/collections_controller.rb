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
    @collection = current_user.collections.create! collection_params
  end

  def update
  end

  def destroy
    Collection.find(params[:id]).destroy!
  end

  private

  def collection_params
    params.permit('name')
  end
end
