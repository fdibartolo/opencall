class StatsController < ApplicationController
  before_action :authenticate_user!
  before_action :forbid_if_no_access

  def index
    @themes = Theme.all
  end

  def show
    
  end

  private
  def forbid_if_no_access
    raise CanCan::AccessDenied unless current_user.admin?
  end
end
