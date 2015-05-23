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

    context "while admin" do
      login_as :admin

      let!(:track) { FactoryGirl.create :track }
      let!(:theme) { FactoryGirl.create :theme }
      let!(:first_session) { FactoryGirl.create :session_proposal, theme: theme, track: track }
      let!(:reviewer) { FactoryGirl.create(:reviewer, first_name: 'reviewer') }
      let!(:first_review) { FactoryGirl.create :review, session_proposal: first_session, user: reviewer, workflow_state: 'accepted' }
      let!(:second_review) { FactoryGirl.create :review, session_proposal: first_session, user: reviewer }
      let!(:second_session) { FactoryGirl.create :session_proposal, user: logged_in(:admin), theme: theme, track: track }
      let!(:third_review) { FactoryGirl.create :review, session_proposal: second_session, user: reviewer }

      it "should include reviews info" do
        get :index

        body = JSON.parse response.body
        expect(body['sessions'].count).to eq 2
        expect(body['sessions'].first['reviews'].count).to eq 2
        expect(body['sessions'].first['reviews'].first['reviewer']).to eq first_review.user.full_name
        expect(body['sessions'].first['reviews'].first['status']).to eq first_review.workflow_state
        expect(body['sessions'].last['reviews'].count).to eq 1
        expect(body['sessions'].last['reviews'].first['reviewer']).to eq third_review.user.full_name
        expect(body['sessions'].last['reviews'].first['status']).to eq third_review.workflow_state
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
end
