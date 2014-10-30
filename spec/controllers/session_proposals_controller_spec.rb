require 'rails_helper'

RSpec.describe SessionProposalsController, :type => :controller do

  describe "GET #new" do
    it "should return an empty json-serialized SessionProposal" do
      get :new

      body = JSON.parse response.body
      expect(body).to include 'author'
      expect(body).to include 'title'
      expect(body).to include 'description'
    end
  end

  describe "POST #create" do
    context "with invalid params" do
      it "should throw exception which ActionController::Base handle it into 400 Bad Request reply" do
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
end
