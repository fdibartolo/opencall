class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :forbid_if_no_access

  def index
    @session_proposals = SessionProposal.all
  end

  private
  def forbid_if_no_access
    return head :forbidden unless current_user.admin?
  end
end
