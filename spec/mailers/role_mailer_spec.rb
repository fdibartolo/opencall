require "rails_helper"

RSpec.describe RoleMailer, type: :mailer do
  describe ".role_created_email" do
    let(:user) { FactoryGirl.create(:user) }
    let(:role_name) { RoleReviewer }
    let(:mail) { RoleMailer.role_created_email(user, role_name).deliver_now }

    it { expect(mail.to).to include user.email }
    it { expect(mail.subject).to eq I18n.t('role_mailer.role_created_email.subject') }
    it { expect(mail.body).to match role_name.titlecase }
  end
end
