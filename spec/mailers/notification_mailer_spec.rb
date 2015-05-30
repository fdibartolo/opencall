require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe ".session_accepted_email" do
    let(:session) { FactoryGirl.create :session_proposal }
    let(:mail) { NotificationMailer.session_accepted_email(session).deliver_now }
    let!(:admin) { FactoryGirl.create :admin, first_name: 'admin' }

    it { expect(mail.to).to include session.user.email }
    it { expect(mail.bcc).to include admin.email }
    it { expect(mail.subject).to eq I18n.t('notification_mailer.session_accepted_email.subject') }
    it { expect(mail.body).to match session.title }
    it { expect(mail.body).to match ChairsAccount }
    it { expect(mail.body).to match AcceptanceDueDate.strftime('%H:%Mhs of %B %d, %Y') }
  end

  describe ".session_declined_email" do
    let(:session) { FactoryGirl.create :session_proposal }
    let(:mail) { NotificationMailer.session_declined_email(session).deliver_now }
    let!(:admin) { FactoryGirl.create :admin, first_name: 'admin' }

    it { expect(mail.to).to include session.user.email }
    it { expect(mail.bcc).to include admin.email }
    it { expect(mail.subject).to eq I18n.t('notification_mailer.session_declined_email.subject') }
    it { expect(mail.body).to match session.title }
    it { expect(mail.body).to match ChairsAccount }
  end
end
