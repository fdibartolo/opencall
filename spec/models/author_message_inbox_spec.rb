require "rails_helper"

describe AuthorMessageInbox do

  let(:inbox) { AuthorMessageInbox.new }

  before :each do
    ActionMailer::Base.deliveries.clear
  end

  context 'author with session' do
    let!(:session_one) { FactoryGirl.create :session_proposal }
    let(:author_one) { session_one.user }

    let!(:session_two) { FactoryGirl.create :session_proposal }
    let(:author_two) { session_two.user }

    it 'should send a message to all authors' do
      subject, body = 'Hi', 'How are you?'
      inbox.message_all(subject, body)

      emails = ActionMailer::Base.deliveries
      last_email = emails.last

      expect(emails.size).to eq(2)
      expect(last_email.to).to include(author_two.email)
      expect(last_email.subject).to eq('Hi')
      expect(last_email.body.encoded).to include('How are you?')
    end
  end
  context 'author with and without sessions' do
    let!(:session_one) { FactoryGirl.create :session_proposal }
    let(:author_one) { session_one.user }

    let!(:user_without_session) { FactoryGirl.create :user }

    it 'should send a message to all authors' do
      subject, body = 'Hi', 'How are you?'
      inbox.message_all(subject, body)

      emails = ActionMailer::Base.deliveries
      last_email = emails.last

      expect(emails.size).to eq(1)
      expect(last_email.to).to include(author_one.email)
      expect(last_email.subject).to eq('Hi')
      expect(last_email.body.encoded).to include('How are you?')
    end
  end

  context 'users without sessions' do
    let!(:user_without_session) { FactoryGirl.create :user }

    it 'should not send a message to a user without a session proposal' do
      subject, body = 'Hi', 'How are you?'
      inbox.message_all(subject, body)

      emails = ActionMailer::Base.deliveries

      expect(emails.empty?).to eq(true)
    end
  end
end