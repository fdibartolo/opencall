require 'rails_helper'

RSpec.describe SessionProposalsController, :type => :controller do
  login_as :user
  
  describe "GET new" do
    it "should return an empty json-serialized SessionProposal" do
      get :new

      body = JSON.parse response.body
      expect(body).to include 'title'
      expect(body).to include 'summary'
      expect(body).to include 'description'
      expect(body).to include 'video_link'
    end
  end

  describe "GET index" do
    it "should list all SessionProposals" do
      session = FactoryGirl.create :session_proposal, track: FactoryGirl.create(:track), theme: FactoryGirl.create(:theme), audience: FactoryGirl.create(:audience)

      get :index

      body = JSON.parse response.body
      expect(body['sessions'].last['id']).to eq session.id
      expect(body['sessions'].last['author']).to eq session.user.full_name
    end
  end

  describe "GET show" do
    context "with invalid params id" do
      before :each do
        allow(SessionProposal).to receive(:find_by).and_return(nil)
        get :show, { id: 9999 }
      end

      it "should return 400 Bad Request" do
        expect(response).to have_http_status(400)
      end

      it "should return 'cannot find' message" do
        expect(response.header['Message']).to eq "Unable to find session proposal with id '9999'"
      end
    end
    context "with valid params" do
      it "should return the SessionProposal for given id" do
        session = FactoryGirl.create :session_proposal, track: FactoryGirl.create(:track), theme: FactoryGirl.create(:theme), audience: FactoryGirl.create(:audience)
        allow(SessionProposal).to receive(:find_by).and_return(session)
        
        get :show, { id: session.id }

        body = JSON.parse response.body
        expect(body['id']).to eq session.id
        expect(body['author']['name']).to eq session.user.full_name
      end
    end
  end

  describe "GET edit" do
    context "while session author" do
      context "with invalid params id" do
        before :each do
          allow(SessionProposal).to receive(:find_by).and_return(nil)
          get :edit, { id: 9999 }
        end

        it "should return 400 Bad Request" do
          expect(response).to have_http_status(400)
        end

        it "should return 'cannot find' message" do
          expect(response.header['Message']).to eq "Unable to find session proposal with id '9999'"
        end
      end
      context "with valid params" do
        it "should return the SessionProposal for given id" do
          session = FactoryGirl.create :session_proposal, user: logged_in
          allow(SessionProposal).to receive(:find_by).and_return(session)
          
          get :edit, { id: session.id }

          body = JSON.parse response.body
          expect(body['id']).to eq session.id
          expect(body['title']).to eq session.title
          expect(body['description']).to eq session.description
        end
      end
    end

    context "while not session author" do
      it "should return forbidden" do
        user = FactoryGirl.create :user, first_name: 'jim'
        session = FactoryGirl.create :session_proposal, user: user

        get :edit, { id: session.id }
        expect(response).to have_http_status(403)
      end
    end
  end

  describe "POST create" do
    context "with invalid params" do
      it "should throw exception which ActionController::Base handle it into 400 Bad Request" do
        expect{ post(:create, {}) }.to raise_error ActionController::ParameterMissing
      end
    end

    context "with valid params" do
      let(:payload) { { session_proposal: { title: 'title', summary: 'summary', description: 'description', track_id: 1 } } }
      let!(:role_admin) { FactoryGirl.create :role }
      
      it "should return success if can save" do
        allow_any_instance_of(SessionProposal).to receive(:save).and_return(true)
        post :create, payload
        expect(response).to have_http_status(204)
      end

      it "should fire email if can save" do
        allow_any_instance_of(SessionProposal).to receive(:save).and_return(true)
        post :create, payload
        email = ActionMailer::Base.deliveries.last
        expect(email.subject).to eq I18n.t('session_proposal_mailer.session_proposal_created_email.subject')
      end

      it "should return unprocesable entity if cannot save" do
        allow_any_instance_of(SessionProposal).to receive(:save).and_return(false)
        post :create, payload
        expect(response).to have_http_status(422)
      end

      it "should return forbidden entity if past due date" do
        travel_to (SubmissionDueDate + 1.minute) do
          post :create, payload
          expect(response).to have_http_status(403)
        end
      end
    end
  end

  describe "PATCH update" do
    context "while session author" do
      context "with invalid params" do
        it "should return 400 Bad Request" do
          allow(SessionProposal).to receive(:find_by).and_return(nil)
          expect(patch(:update, { id: 9999 })).to have_http_status(400)
        end
      end

      context "with valid params" do
        let(:session) { FactoryGirl.create :session_proposal, user: logged_in }
        let(:payload) { { id: session.id, session_proposal: { title: 'title' } } }
        
        it "should return success if can save" do
          allow_any_instance_of(SessionProposal).to receive(:update).and_return(true)
          patch :update, payload
          expect(response).to have_http_status(204)
        end

        it "should return unprocesable entity if cannot save" do
          allow_any_instance_of(SessionProposal).to receive(:update).and_return(false)
          patch :update, payload
          expect(response).to have_http_status(422)
        end
      end
    end

    context "while not session author" do
      it "should return forbidden" do
        user = FactoryGirl.create :user, first_name: 'jim'
        session = FactoryGirl.create :session_proposal, user: user

        post :update, { id: session.id, session_proposal: { title: 'title' } }
        expect(response).to have_http_status(403)
      end
    end
  end

  describe "GET author" do
    let(:author) { FactoryGirl.create :user, first_name: 'author', bio: 'my bio', twitter: '@author' }
    let(:session) { FactoryGirl.create :session_proposal, user: author }

    context "while user" do
      it "should return forbidden" do
        get :author, { id: session.id }
        expect(response).to have_http_status(403)
      end
    end

    context "while reviewer" do
      login_as :reviewer, 'Reviewer'

      it "should return profile info" do
        get :author, { id: session.id }

        body = JSON.parse response.body
        expect(body['bio']).to eq author.bio
        expect(body['twitter']).to eq author.twitter
        expect(body['facebook']).to be_nil
      end
    end
  end

  describe "GET all for current user" do
    it "should list only current user ones" do
      user_session = FactoryGirl.create :session_proposal, user: logged_in, track: FactoryGirl.create(:track), theme: FactoryGirl.create(:theme)
      another_session = FactoryGirl.create :session_proposal

      get :for_current_user

      body = JSON.parse response.body
      session_ids = body['sessions'].collect {|s| s['id']}
      expect(session_ids).to include user_session.id
      expect(session_ids).to_not include another_session.id
    end
  end

  describe "GET all voted for current user" do
    it "should list only current user voted ones" do
      track = FactoryGirl.create(:track)
      theme = FactoryGirl.create(:theme)
      voted_session = FactoryGirl.create :session_proposal, theme: theme, track: track
      not_voted_session = FactoryGirl.create :session_proposal, user: FactoryGirl.create(:user, first_name: 'jim'), track: track
      # HACK :S - why cant do logged_in(:user).session_proposal_voted_ids << voted_session.id 
      logged_in_user = User.find_by(email: logged_in.email)
      logged_in_user.session_proposal_voted_ids << voted_session.id
      logged_in_user.save!

      get :voted_for_current_user

      body = JSON.parse response.body
      session_ids = body['sessions'].collect {|s| s['id']}
      expect(session_ids).to include voted_session.id
      expect(session_ids).to_not include not_voted_session.id
    end
  end

  describe "GET all faved for current user" do
    it "should list only current user faved ones" do
      track = FactoryGirl.create(:track)
      theme = FactoryGirl.create(:theme)
      faved_session = FactoryGirl.create :session_proposal, theme: theme, track: track
      not_faved_session = FactoryGirl.create :session_proposal, user: FactoryGirl.create(:user, first_name: 'jim'), track: track
      # HACK :S - why cant do logged_in(:user).session_proposal_faved_ids << faved_session.id 
      logged_in_user = User.find_by(email: logged_in.email)
      logged_in_user.session_proposal_faved_ids << faved_session.id
      logged_in_user.save!

      get :faved_for_current_user

      body = JSON.parse response.body
      session_ids = body['sessions'].collect {|s| s['id']}
      expect(session_ids).to include faved_session.id
      expect(session_ids).to_not include not_faved_session.id
    end
  end

  describe "GET reviewer comments" do
    context "while user" do
      it "should return forbidden" do
        get :reviewer_comments
        expect(response).to have_http_status(403)
      end
    end

    context "while reviewer" do
      let(:theme) { FactoryGirl.create :theme }
      let!(:first_session) { FactoryGirl.create :session_proposal, theme: theme }
      let!(:role_admin) { FactoryGirl.create :role }

      login_as :reviewer, 'Reviewer'

      it "should include themes list" do
        another_theme = FactoryGirl.create :theme, name: 'Another theme'
        get :reviewer_comments

        body = JSON.parse response.body
        expect(body['themes'].count).to eq 2
        expect(body['themes'].first).to eq theme.name
        expect(body['themes'].last).to eq another_theme.name
      end

      context "while having commented sessions" do
        let!(:second_session) { FactoryGirl.create :session_proposal, theme: theme, user: logged_in }

        it "should include session info" do
          get :reviewer_comments

          body = JSON.parse response.body
          expect(body['sessions'].count).to eq 2
          expect(body['sessions'].first['id']).to eq first_session.id
          expect(body['sessions'].first['title']).to eq first_session.title
          expect(body['sessions'].first['theme']).to eq first_session.theme.name
          expect(body['sessions'].last['id']).to eq second_session.id
          expect(body['sessions'].last['title']).to eq second_session.title
          expect(body['sessions'].last['theme']).to eq second_session.theme.name
        end

        it "should include count of comments only from reviewers" do
          user_comment = FactoryGirl.create :comment, session_proposal: first_session, user: FactoryGirl.create(:user, first_name: 'user')
          another_user_comment = FactoryGirl.create :comment, session_proposal: second_session, user: FactoryGirl.create(:user, first_name: 'user2')
          reviewer_comment = FactoryGirl.create :comment, session_proposal: first_session, user: logged_in

          get :reviewer_comments

          body = JSON.parse response.body
          expect(body['sessions'].first['comments'].count).to eq 1
          expect(body['sessions'].first['comments'].first['reviewer']).to eq reviewer_comment.user.full_name 
          expect(body['sessions'].last['comments'].count).to eq 0
        end
      end
    end
  end

  describe "GET export" do
    context "while user" do
      login_as :reviewer

      it "should return forbidden" do
        get :export, format: :csv
        expect(response).to have_http_status(403)
      end
    end

    context "while reviewer" do
      login_as :admin

      it "should return success" do
        get :export, format: :csv
        expect(response).to have_http_status(200)
      end

      it "should trigger SessionProposal csv conversion" do
        expect(SessionProposal).to receive(:to_csv)
        get :export, format: :csv
      end
    end
  end
end
