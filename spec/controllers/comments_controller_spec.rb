require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do
  login_as :user

  describe "GET index" do
    context "with invalid params" do
      before :each do
        allow(SessionProposal).to receive(:find_by).and_return(nil)
        get :index, { session_proposal_id: 9999 }
      end

      it "should return 400 Bad Request" do
        expect(response).to have_http_status(400)
      end

      it "should return 'cannot find' message" do
        expect(response.header['Message']).to eq "Unable to find session proposal with id '9999'"
      end
    end

    context "with valid params" do
      let(:session) { FactoryGirl.create :session_proposal_with_comment }

      it "should list comments for given SessionProposal" do
        get :index, { session_proposal_id: session.id } 

        body = JSON.parse response.body
        expect(body['comments'].count).to eq 1
        expect(body['comments'].first['body']).to eq session.comments.first.body
        expect(body['comments'].first['author']['name']).to eq session.comments.first.user.full_name
      end
    end
  end

  describe "POST create" do
    context "with valid params" do
      let(:session) { FactoryGirl.create :session_proposal_with_comment }
      let(:payload) { { session_proposal_id: session.id, comment: { body: 'new comment' }}}

      it "should add commento to given SessionProposal" do
        post :create, payload
        expect(response).to have_http_status(204)
        expect(session.comments.count).to eq 2
        expect(session.comments.last.body).to eq 'new comment'
      end
    end
  end
end