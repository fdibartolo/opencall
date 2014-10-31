require 'rails_helper'

RSpec.describe SessionProposalsController, :type => :controller do

  describe "GET new" do
    it "should return an empty json-serialized SessionProposal" do
      get :new

      body = JSON.parse response.body
      expect(body).to include 'author'
      expect(body).to include 'title'
      expect(body).to include 'description'
    end
  end

  describe "GET index" do
    it "should list all SessionProposals" do
      session = FactoryGirl.create :session_proposal

      get :index

      body = JSON.parse response.body
      expect(body.count).to be 1
      expect(body.first['id']).to eq session.id
      expect(body.first['author']).to eq session.author
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

        get :show, { id: session.id }

        body = JSON.parse response.body
        expect(body['id']).to eq session.id
        expect(body['author']).to eq session.author
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
      let(:payload) { { session_proposal: { author: 'author', title: 'title', description: 'description' } } }
      
      it "should return success if can save" do
        allow_any_instance_of(SessionProposal).to receive(:save).and_return(true)
        post :create, payload
        expect(response).to have_http_status(200)
      end

      it "should return unprocesable entity if cannot save" do
        allow_any_instance_of(SessionProposal).to receive(:save).and_return(false)
        post :create, payload
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "PATCH update" do
    context "with invalid params" do
      it "should return 400 Bad Request" do
        allow(SessionProposal).to receive(:find_by).and_return(nil)
        expect(patch(:update, { id: 9999 })).to have_http_status(400)
      end
    end

    context "with valid params" do
      let(:session) { FactoryGirl.create :session_proposal }
      let(:payload) { { id: session.id, session_proposal: { author: 'author', title: 'title' } } }
      
      it "should return success if can save" do
        allow_any_instance_of(SessionProposal).to receive(:update).and_return(true)
        patch :update, payload
        expect(response).to have_http_status(200)
      end

      it "should return unprocesable entity if cannot save" do
        allow_any_instance_of(SessionProposal).to receive(:update).and_return(false)
        patch :update, payload
        expect(response).to have_http_status(422)
      end
    end
  end
end
