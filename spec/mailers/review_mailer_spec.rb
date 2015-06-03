require "rails_helper"

RSpec.describe ReviewMailer, type: :mailer do
  describe ".review_created_email" do
    let(:second_reviewer) { FactoryGirl.create :user, first_name: 'second' }
    let(:review) { FactoryGirl.create :review, user: FactoryGirl.create(:user), second_reviewer_id: second_reviewer.id }
    let(:mail) { ReviewMailer.review_created_email(review).deliver_now }
    let!(:admin) { FactoryGirl.create :admin, first_name: 'admin' }

    it { expect(mail.to).to include admin.email }
    it { expect(mail.subject).to eq I18n.t('review_mailer.review_created_email.subject') }
    it { expect(mail.body).to match review.user.full_name }
    it { expect(mail.body).to match review.session_proposal.title }
    it { expect(mail.body).to match "Score: #{review.score}" }
    it { expect(mail.body).to match "Details: #{review.body}" }
    it { expect(mail.body).to match "Reviewed with: #{second_reviewer.full_name}" }
    it { expect(mail.body).to match "/#/sessions/show/#{review.session_proposal.id}" }
  end
end
