require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe ".session_accepted_email" do
    let(:session) { FactoryGirl.create :session_proposal }
    let(:body) { 'this is the email body' }
    let(:mail) { NotificationMailer.session_accepted_email(session, body).deliver_now }
    let!(:admin) { FactoryGirl.create :admin, first_name: 'admin' }

    it { expect(mail.to).to include session.user.email }
    it { expect(mail.bcc).to include admin.email }
    it { expect(mail.subject).to eq I18n.t('notification_mailer.session_accepted_email.subject') }
    it { expect(mail.body).to match body }
  end

  describe ".session_declined_email" do
    let(:session) { FactoryGirl.create :session_proposal }
    let(:body) { 'this is the email body' }
    let(:mail) { NotificationMailer.session_declined_email(session, body).deliver_now }
    let!(:admin) { FactoryGirl.create :admin, first_name: 'admin' }

    it { expect(mail.to).to include session.user.email }
    it { expect(mail.bcc).to include admin.email }
    it { expect(mail.subject).to eq I18n.t('notification_mailer.session_declined_email.subject') }
    it { expect(mail.body).to match body }
  end

  describe ".general_notification_email" do
    let(:author) { FactoryGirl.create :user }
    let(:subject) { "Some subject" }
    let(:body) { "Some body" }
    let(:mail) { NotificationMailer.general_notification_email(author.email, subject, body).deliver_now }

    it { expect(mail.to).to include author.email }
    it { expect(mail.bcc).to be nil }
    it { expect(mail.subject).to eq subject }
    it { expect(mail.body).to match body }
  end
end
