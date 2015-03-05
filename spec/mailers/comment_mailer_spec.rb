require "rails_helper"

RSpec.describe CommentMailer, type: :mailer do
  describe ".comment_created_email" do
    let(:comment) { FactoryGirl.create(:session_proposal_with_comment).comments.first }
    let(:mail) { CommentMailer.comment_created_email(comment).deliver_now }

    it { expect(mail.to).to include comment.session_proposal.user.email }
    it { expect(mail.subject).to eq I18n.t('comment_mailer.comment_created_email.subject') }
    it { expect(mail.body).to match comment.session_proposal.title }
    it { expect(mail.body).to match comment.body }
    it { expect(mail.body).to match "/#/sessions/show/#{comment.session_proposal.id}" }
  end
end
