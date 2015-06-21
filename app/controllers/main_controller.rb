class MainController < ApplicationController
  before_action :missing_bio, only: :index

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

  private
  def missing_bio
    if current_user and current_user.author? and current_user.missing_bio?
      flash[:alert] = I18n.t 'flash.missing_bio'
      redirect_to edit_user_registration_path
    end
  end
end
