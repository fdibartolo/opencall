class TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    tags = [{"text": "Lorem"}, {"text": "labore"}, {"text": "laboris"}, {"text": "laborum"}]
    render json: tags
  end

  def suggest
    tags = Tag.suggest params[:q]
    render json: tags
  end
end
