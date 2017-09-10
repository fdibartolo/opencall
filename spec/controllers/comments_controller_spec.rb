require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do
  login_as :user

  describe "GET index" do
    context "with invalid params" do
      before :each do
        allow(SessionProposal).to receive(:find_by).and_return(nil)
        get :index, params: { session_proposal_id: 9999 }
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
        get :index, params: { session_proposal_id: session.id } 

        body = JSON.parse response.body
        expect(body['comments'].count).to eq 1
        expect(body['comments'].first['body']).to eq session.comments.first.body
        expect(body['comments'].first['author']['name']).to eq session.comments.first.user.full_name
        expect(body['comments'].first['author']['is_reviewer']).to be (session.comments.first.user.reviewer? or session.comments.first.user.admin?)
      end
    end
  end

  describe "POST create" do
    context "with valid params" do
      let(:session) { FactoryGirl.create :session_proposal_with_comment }
      let(:payload) { { session_proposal_id: session.id, comment: { body: 'new comment' }}}

      it "should add comment to given SessionProposal" do
        post :create, params: payload
        expect(response).to have_http_status(204)
        expect(session.comments.count).to eq 2
        expect(session.comments.last.body).to eq 'new comment'
      end

      it "should fire email" do
        allow_any_instance_of(Comment).to receive(:save).and_return(true)
        post :create, params: payload
        email = ActionMailer::Base.deliveries.last
        expect(email.subject).to eq I18n.t('comment_mailer.comment_created_email.subject')
      end
    end
  end
end