class SessionProposalMailer < ApplicationMailer
  def session_proposal_created_email session_proposal
    @user = session_proposal.user
    @session_proposal = session_proposal
    mail to: @user.email, bcc: administrators
  end

  private
  def administrators
    Role.find_by(name: RoleAdmin).users.pluck(:email)
  end
end
