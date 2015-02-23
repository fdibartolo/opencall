require 'rails_helper'

RSpec.describe SessionProposalsController, :type => :controller do
  login_as :user
  
  describe "GET new" do
    it "should return an empty json-serialized SessionProposal" do
      get :new

      body = JSON.parse response.body
      expect(body).to include 'title'
      expect(body).to include 'description'
    end
  end

  describe "GET index" do
    it "should list all SessionProposals" do
      session = FactoryGirl.create :session_proposal

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
        session = FactoryGirl.create :session_proposal
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
          session = FactoryGirl.create :session_proposal, user: logged_in(:user)
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
      let(:payload) { { session_proposal: { title: 'title', description: 'description', track_id: 1 } } }
      
      it "should return success if can save" do
        allow_any_instance_of(SessionProposal).to receive(:save).and_return(true)
        post :create, payload
        expect(response).to have_http_status(204)
      end

      it "should return unprocesable entity if cannot save" do
        allow_any_instance_of(SessionProposal).to receive(:save).and_return(false)
        post :create, payload
        expect(response).to have_http_status(422)
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
        let(:session) { FactoryGirl.create :session_proposal, user: logged_in(:user) }
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

  describe "GET all for current user" do
    it "should list only current user ones" do
      user_session = FactoryGirl.create :session_proposal, user: logged_in(:user)
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
      voted_session = FactoryGirl.create :session_proposal
      not_voted_session = FactoryGirl.create :session_proposal, user: FactoryGirl.create(:user, first_name: 'jim')
      # HACK :S - why cant do logged_in(:user).session_proposal_voted_ids << voted_session.id 
      logged_in_user = User.find_by(email: logged_in(:user).email)
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
      faved_session = FactoryGirl.create :session_proposal
      not_faved_session = FactoryGirl.create :session_proposal, user: FactoryGirl.create(:user, first_name: 'jim')
      # HACK :S - why cant do logged_in(:user).session_proposal_faved_ids << faved_session.id 
      logged_in_user = User.find_by(email: logged_in(:user).email)
      logged_in_user.session_proposal_faved_ids << faved_session.id
      logged_in_user.save!

      get :faved_for_current_user

      body = JSON.parse response.body
      session_ids = body['sessions'].collect {|s| s['id']}
      expect(session_ids).to include faved_session.id
      expect(session_ids).to_not include not_faved_session.id
    end
  end
end
