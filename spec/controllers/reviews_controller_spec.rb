require 'rails_helper'

RSpec.describe ReviewsController, :type => :controller do
  login_user

  describe "POST create" do
    context "with valid params" do
      let(:session) { FactoryGirl.create :session_proposal }
      let(:payload) { { session_proposal_id: session.id, review: { body: 'new review', score: 8 }}}

      it "should add review to given SessionProposal" do
        post :create, payload
        expect(response).to have_http_status(204)
        expect(session.reviews.count).to eq 1
        expect(session.reviews.last.body).to eq 'new review'
        expect(session.reviews.last.score).to eq 8
      end
    end
  end
end