require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  describe "GET #index for reviews by session" do
    context "while user" do
      login_as :user

      it "should return forbidden" do
        get :index
        expect(response).to have_http_status(403)
      end
    end

    context "while reviewer" do
      login_as :reviewer

      let!(:track) { FactoryGirl.create :track }
      let!(:theme) { FactoryGirl.create :theme }
      let!(:first_session) { FactoryGirl.create :session_proposal, theme: theme, track: track }
      let!(:reviewer) { FactoryGirl.create(:reviewer, first_name: 'reviewer') }
      let!(:second_reviewer) { FactoryGirl.create(:user, first_name: 'second') }
      let!(:first_review) { FactoryGirl.create :review, session_proposal: first_session, user: reviewer, workflow_state: 'accepted', second_reviewer_id: second_reviewer.id }
      let!(:second_review) { FactoryGirl.create :review, session_proposal: first_session, user: reviewer, second_reviewer_id: second_reviewer.id }
      let!(:second_session) { FactoryGirl.create :session_proposal, user: @logged_user, theme: theme, track: track }
      let!(:third_review) { FactoryGirl.create :review, session_proposal: second_session, user: reviewer, second_reviewer_id: second_reviewer.id }

      it "should include reviews info" do
        get :index

        body = JSON.parse response.body
        expect(body['sessions'].count).to eq 2
        expect(body['sessions'].first['reviews'].count).to eq 2
        expect(body['sessions'].first['reviews'].first['reviewer']).to eq first_review.user.full_name
        expect(body['sessions'].first['reviews'].first['status']).to eq first_review.workflow_state
        expect(body['sessions'].first['reviews'].first['second_reviewer']).to eq second_reviewer.full_name
        expect(body['sessions'].last['reviews'].count).to eq 1
        expect(body['sessions'].last['reviews'].first['reviewer']).to eq third_review.user.full_name
        expect(body['sessions'].last['reviews'].first['status']).to eq third_review.workflow_state
        expect(body['sessions'].last['reviews'].first['second_reviewer']).to eq second_reviewer.full_name
      end

      it "should include session status" do
        second_session.accept!
        get :index

        body = JSON.parse response.body
        expect(body['sessions'].count).to eq 2
        expect(body['sessions'].first['status']).to eq first_session.workflow_state
        expect(body['sessions'].first['notified_on']).to be nil
        expect(body['sessions'].last['status']).to eq 'accepted'
      end

      it "should include themes list" do
        another_theme = FactoryGirl.create :theme, name: 'Another theme'
        get :index

        body = JSON.parse response.body
        expect(body['themes'].count).to eq 2
        expect(body['themes'].first).to eq theme.name
        expect(body['themes'].last).to eq another_theme.name
      end
    end
  end

  {
    'acceptance_template' => 'We are pleased to inform you',
    'denial_template' => 'We regret to inform you'
  }.each do |action, expected_text|
    describe "GET #{action}" do
      context "while reviewer" do
        login_as :reviewer

        it "should return forbidden" do
          post :notify_authors
          expect(response).to have_http_status(403)
        end
      end

      context "while admin" do
        login_as :admin

        let(:session) { FactoryGirl.create :session_proposal }
        let(:payload) { { session_proposal_id: session.id } }

        it "should include template" do
          get action, payload

          body = JSON.parse response.body
          expect(body['template']).to match "Dear #{session.user.full_name},\n\n#{expected_text}"
        end

        it "should include reviews public feedback" do
          first_review  = FactoryGirl.create :review, session_proposal: session, user: @logged_user, body: 'something'
          second_review = FactoryGirl.create :review, session_proposal: session, user: @logged_user, body: 'another comment'

          get action, payload

          body = JSON.parse response.body
          expect(body['feedback'].count).to eq 2
          expect(body['feedback'].first).to eq first_review.body
          expect(body['feedback'].last).to eq second_review.body
        end
      end
    end
  end

  {
    'accept' => 'accepted',
    'decline' => 'declined'
  }.each do |action, status|
    describe "POST #{action}" do
      let(:session) { FactoryGirl.create :session_proposal }
      let(:payload) { { session_proposal_id: session.id } }

      context "while reviewer" do
        login_as :reviewer

        it "should return forbidden" do
          post action, payload
          expect(response).to have_http_status(403)
        end
      end

      context "while admin" do
        login_as :admin

        context "with invalid param id" do
          before :each do
            allow(Review).to receive(:find_by).and_return(nil)
            payload[:session_proposal_id] = 0
            post action, payload
          end

          it "should return 400 Bad Request" do
            expect(response).to have_http_status(400)
          end

          it "should return 'cannot find' message" do
            expect(response.header['Message']).to eq "Unable to find session proposal with id '0'"
          end
        end

        context "with valid params" do
          it "should update session proposal to '#{status}' status" do
            post action, payload
            expect(eval("session.reload.#{status}?")).to be true
          end

          it "should fire '#{status}' email from new status" do
            allow_any_instance_of(SessionProposal).to receive(action).and_return(true)
            post action, payload
            email = ActionMailer::Base.deliveries.last
            expect(email.subject).to eq I18n.t("notification_mailer.session_#{status}_email.subject")
          end

          it "should fire '#{status}' email even if already #{status}" do
            eval("session.#{action}!")
            allow_any_instance_of(SessionProposal).to receive(action).and_return(true)
            post action, payload
            email = ActionMailer::Base.deliveries.last
            expect(email.subject).to eq I18n.t("notification_mailer.session_#{status}_email.subject")
          end
        end
      end
    end
  end

  describe "POST #notify_authors" do
    context "while user" do
      login_as :user

      it "should return forbidden" do
        post :notify_authors
        expect(response).to have_http_status(403)
      end
    end

    context "while admin" do
      login_as :admin

      context "with missing params" do
        it "should throw exception which ActionController::Base handle it into 400 Bad Request" do
          expect{ post(:notify_authors, {}) }.to raise_error ActionController::ParameterMissing
        end
      end

      context "with valid params" do
        let(:payload) { { message: { subject: "some subject", body: "some body" } } }

        it "should fire email" do
          expect_any_instance_of(AuthorMessageInbox).to receive(:message_all).
            with(payload[:message][:subject], payload[:message][:body])

          post :notify_authors, payload
        end
      end
    end
  end
end
