class SessionProposalMailer < ApplicationMailer
  def session_proposal_created_email session_proposal
    @user = session_proposal.user
    @session_proposal = session_proposal
    mail(to: @user.email, subject: 'Agiles 2015 - Session proposal submitted')
  end
end
