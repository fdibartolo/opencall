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
    let(:payload) { { session_proposal_id: session.id, review: { body: 'new review', score: 8, second_reviewer_id: 1 }}}
    let!(:admin) { FactoryGirl.create :admin, first_name: 'admin' }

    context "while user" do
      login_as :user

      it "should return forbidden" do
        post :create, payload
        expect(response).to have_http_status(403)
      end
    end

    context "while reviewer" do
      login_as :reviewer

      it "should create review to given SessionProposal when no one exists" do
        post :create, payload
        expect(response).to have_http_status(204)
        expect(session.reviews.count).to eq 1
        expect(session.reviews.last.body).to eq 'new review'
        expect(session.reviews.last.score).to eq 8
        expect(session.reviews.last.second_reviewer_id).to eq 1
      end

      it "should update review to given SessionProposal when one exists" do
        FactoryGirl.create :review, session_proposal: session, user: logged_in(:reviewer)
        payload[:review][:body] = 'updated'
        payload[:review][:score] = 10
        post :create, payload
        expect(response).to have_http_status(204)
        expect(session.reviews.count).to eq 1
        expect(session.reviews.last.body).to eq 'updated'
        expect(session.reviews.last.score).to eq 10
      end

      it "should fire email on create" do
        allow_any_instance_of(Review).to receive(:save).and_return(true)
        post :create, payload
        email = ActionMailer::Base.deliveries.last
        expect(email.subject).to eq I18n.t('review_mailer.review_created_email.subject')
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
        expect(body['reviews'].first['status']).to eq reviewers_review.workflow_state
      end
    end
  end

  describe "GET single for current user" do
    let(:session) { FactoryGirl.create :session_proposal }

    context "while user" do
      login_as :user

      it "should return forbidden" do
        get :single_for_current_user, { session_proposal_id: session.id }
        expect(response).to have_http_status(403)
      end
    end

    context "while reviewer" do
      login_as :reviewer
      let!(:admin) { FactoryGirl.create :admin, first_name: 'admin' }

      context "with invalid param id" do
        before :each do
          allow(SessionProposal).to receive(:find_by).and_return(nil)
          get :single_for_current_user, { session_proposal_id: 0 }
        end

        it "should return 400 Bad Request" do
          expect(response).to have_http_status(400)
        end

        it "should return 'cannot find' message" do
          expect(response.header['Message']).to eq "Unable to find session proposal with id '0'"
        end
      end

      context "with valid params" do
        let(:second_session) { FactoryGirl.create :session_proposal, user: session.user }
        let(:second_review) { FactoryGirl.create :review, session_proposal: second_session, user: logged_in(:reviewer) }

        it "should return review info when one exists" do
          review = FactoryGirl.create :review, session_proposal: session, user: logged_in(:reviewer)

          get :single_for_current_user, { session_proposal_id: session.id }

          body = JSON.parse response.body
          expect(body['body']).to eq review.body
          expect(body['score']).to eq review.score
          expect(body['status']).to eq review.workflow_state
        end

        it "should not return reviews body when no one exists" do
          get :single_for_current_user, { session_proposal_id: session.id }

          body = JSON.parse response.body
          expect(body['body']).to be nil
        end

        it "should include all valid reviewers" do
          get :single_for_current_user, { session_proposal_id: session.id }

          body = JSON.parse response.body
          expect(body['reviewers'].count).to be 2
          expect(body['reviewers'][0]['id']).to eq admin.id
          expect(body['reviewers'][1]['id']).to eq logged_in(:reviewer).id
        end
      end
    end
  end

  {
    'accept' => 'accepted',
    'reject' => 'rejected'
  }.each do |action, status|
    describe "POST #{action}" do
      let(:session) { FactoryGirl.create :session_proposal }
      let(:review) { FactoryGirl.create :review, session_proposal: session, user: logged_in(:reviewer) }
      let(:payload) { { session_proposal_id: session.id, id: review.id } }

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
            payload[:id] = 0
            post action, payload
          end

          it "should return 400 Bad Request" do
            expect(response).to have_http_status(400)
          end

          it "should return 'cannot find' message" do
            expect(response.header['Message']).to eq "Unable to find review with id '0'"
          end
        end

        context "with valid params" do
          it "should update review to '#{status}' status" do
            post action, payload
            expect(eval("review.reload.#{status}?")).to be true
            # expect(review).to receive(:accept!).exactly(1).times
          end
        end
      end
    end
  end
end