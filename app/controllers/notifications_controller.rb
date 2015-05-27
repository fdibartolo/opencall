class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :forbid_if_no_access
  before_action only: [:accept, :decline] do
    set_resource SessionProposal, params[:session_proposal_id]
  end

  def index
    @session_proposals = SessionProposal.all
  end

  def accept
    @session_proposal.accept! if @session_proposal.can_accept?
    NotificationMailer.session_accepted_email(@session_proposal).deliver_now if @session_proposal.accepted?
    head :no_content
  end

  def decline
    @session_proposal.decline! if @session_proposal.can_decline?
    NotificationMailer.session_declined_email(@session_proposal).deliver_now if @session_proposal.declined?
    head :no_content
  end

  private
  def forbid_if_no_access
    return head :forbidden unless current_user.admin?
  end
end
