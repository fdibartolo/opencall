class TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    tags = Tag.search_all
    render json: tags.results
  end

  def suggest
    tags = Tag.suggest params[:q]
    render json: tags
  end
end
