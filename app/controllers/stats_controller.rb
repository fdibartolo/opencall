class StatsController < ApplicationController
  before_action :authenticate_user!
  before_action :forbid_if_no_access
  before_action :set_theme, only: :show

  def index
    @themes = Theme.all
  end

  def show
  end

  private
  def forbid_if_no_access
    return head :forbidden unless current_user.admin?
  end

  def set_theme
    set_resource Theme, :id
  end
end
