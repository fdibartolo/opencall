class MainController < ApplicationController
  def index
  end

  def version
  	response.stream.write Version
  	response.stream.write("-" + ENV["commit_id"]) if ENV["commit_id"]
  	response.stream.close
  end

end
