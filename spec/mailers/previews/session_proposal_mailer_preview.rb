# Preview all emails at http://localhost:3000/rails/mailers/session_proposal_mailer
class SessionProposalMailerPreview < ActionMailer::Preview
  def create
    SessionProposalMailer.session_proposal_created_email(SessionProposal.first)
  end
end
