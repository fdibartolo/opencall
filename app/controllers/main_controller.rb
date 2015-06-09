class MainController < ApplicationController
  def index
  end

  def version
  	response.stream.write Version
  	path = File.expand_path('../../../public/commit_track.txt', __FILE__)
  	if File.exist?(path) 
  		commit = File.read(path)
  		response.stream.write("-" + commit)
  	end
  	response.stream.close
  end

end
