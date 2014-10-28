class TemplatesController < ApplicationController
  def template
    render :template => 'templates/' + params[:path], :layout => nil
  end
end
