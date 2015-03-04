require "rails_helper"

RSpec.describe SessionProposalMailer, type: :mailer do
  describe ".session_proposal_created_email" do
    let(:session_proposal) { FactoryGirl.create :session_proposal }
    let(:mail) { SessionProposalMailer.session_proposal_created_email(session_proposal).deliver_now }

    it { expect(mail.to).to include session_proposal.user.email }
    it { expect(mail.subject).to eq 'Agiles 2015 - Session proposal submitted' }
    it { expect(mail.body).to match session_proposal.title }
    it { expect(mail.body).to match "/#/sessions/show/#{session_proposal.id}" }
  end
end
