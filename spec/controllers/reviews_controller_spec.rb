require 'rails_helper'

RSpec.describe ReviewsController, :type => :controller do
  describe "GET all for given session proposal" do
    let(:session) { FactoryGirl.create :session_proposal }

    context "while user" do
      login_as :user

      it "should return forbidden" do
        get :index, { session_proposal_id: session.id }
        expect(response).to have_http_status(403)
      end
    end

    context "while reviewer" do
      login_as :reviewer

      it "should return all reviews" do
        reviewers_review = FactoryGirl.create :review, session_proposal: session, user: logged_in(:reviewer)
        admins_review = FactoryGirl.create :review, session_proposal: session, user: FactoryGirl.create(:admin, first_name: 'admin')

        get :index, { session_proposal_id: session.id }

        body = JSON.parse response.body
        expect(body['reviews'].count).to eq 2
        expect(body['reviews'].first['reviewer']).to eq reviewers_review.user.full_name
        expect(body['reviews'].last['reviewer']).to eq admins_review.user.full_name
      end
    end
  end

  describe "POST create" do
    let(:session) { FactoryGirl.create :session_proposal }
    let(:payload) { { session_proposal_id: session.id, review: { body: 'new review', score: 8 }}}

    context "while user" do
      login_as :user

      it "should return forbidden" do
        post :create, payload
        expect(response).to have_http_status(403)
      end
    end

    context "while reviewer" do
      login_as :reviewer

      it "should add review to given SessionProposal" do
        post :create, payload
        expect(response).to have_http_status(204)
        expect(session.reviews.count).to eq 1
        expect(session.reviews.last.body).to eq 'new review'
        expect(session.reviews.last.score).to eq 8
      end
    end
  end

  describe "GET all for current user" do
    context "while user" do
      login_as :user

      it "should return forbidden" do
        get :for_current_user
        expect(response).to have_http_status(403)
      end
    end

    context "while reviewer" do
      login_as :reviewer

      it "should return only owned reviews" do
        first_session = FactoryGirl.create :session_proposal
        reviewers_review = FactoryGirl.create :review, session_proposal: first_session, user: logged_in(:reviewer)
        second_session = FactoryGirl.create :session_proposal, user: first_session.user
        admins_review = FactoryGirl.create :review, session_proposal: second_session, user: FactoryGirl.create(:admin, first_name: 'admin')

        get :for_current_user

        body = JSON.parse response.body
        expect(body['reviews'].count).to eq 1
        expect(body['reviews'].first['session_proposal_id']).to eq first_session.id
        expect(body['reviews'].first['session_proposal_title']).to eq first_session.title
        expect(body['reviews'].first['body']).to eq reviewers_review.body
        expect(body['reviews'].first['score']).to eq reviewers_review.score
      end
    end
  end
end