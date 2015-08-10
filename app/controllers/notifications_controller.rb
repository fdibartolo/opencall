class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :forbid_if_cannot_list, only: :index
  before_action :forbid_if_no_access, except: :index
  before_action only: [:accept, :decline, :acceptance_template, :denial_template] do
    set_resource SessionProposal, params[:session_proposal_id]
  end

  def index
    @session_proposals = SessionProposal.all
  end

  def acceptance_template
  end

  def denial_template
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

  def notify_authors
    subject, body = notify_author_params[:subject], notify_author_params[:body]
    AuthorMessageInbox.new.message_all subject, body
    head :no_content
  end

  private
  def forbid_if_cannot_list
    return head :forbidden if cannot? :list, SessionProposal
  end

  def forbid_if_no_access
    return head :forbidden unless current_user.admin?
  end

  def notify_author_params
    params.require(:message).permit(:subject, :body)
  end
end
