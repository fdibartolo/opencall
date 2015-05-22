class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :forbid_if_no_access
  before_action :set_session_proposal, only: [:accept, :decline]

  def index
    @session_proposals = SessionProposal.all
  end

  def accept
    @session_proposal.accept!
    head :no_content
  end

  def decline
    @session_proposal.decline!
    head :no_content
  end

  private
  def forbid_if_no_access
    return head :forbidden unless current_user.admin?
  end

  def set_session_proposal
    @session_proposal = SessionProposal.find_by(id: params[:id])
    return head(:bad_request, { message: "Unable to find session proposal with id '#{params[:id]}'"}) unless @session_proposal
  end
end
