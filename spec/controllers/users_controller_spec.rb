require 'rails_helper'

RSpec.describe Users::UsersController, :type => :controller do
  login_as :user

  describe "GET reset_password" do
    subject { get :reset_password }

    it "should set token and redirect to default devise form" do
      expect_any_instance_of(User).to receive(:save).twice.and_return(true) # sign_out also calls save on user :S
      expect(subject.location).to include edit_user_password_path(reset_password_token: nil)
    end
  end

  describe "GET unlink social" do
    let(:identity) { FactoryGirl.create :identity, user: logged_in }

    before :each do
      get :unlink_social, params: { provider: identity.provider }
    end

    it { expect(logged_in.identities).to_not include identity }
    it { expect(response).to redirect_to(edit_user_registration_path(logged_in)) }
    it { expect(request.flash[:notice]).to include I18n.t('flash.unlink_social_ok', provider: identity.provider) }
  end

  describe "GET session voted ids" do
    it "should list the ones for current user" do
      allow_any_instance_of(User).to receive(:session_proposal_voted_ids).and_return([1,2,3])

      get :session_proposal_voted_ids

      body = JSON.parse response.body
      expect(body.count).to eq 3
      expect(body).to eq [1,2,3]
    end
  end

  describe "POST toggle session vote" do
    context "with invalid params" do
      before :each do
        post :toggle_session_vote, params: { invalid: 1, vote: true }
      end

      it "should return 400 Bad Request" do
        expect(response).to have_http_status(400)
      end

      it "should return missing params message" do
        expect(response.header['Message']).to eq "Missing params either id or vote"
      end
    end

    context "with valid params" do
      it "should add vote when param is true" do
        post :toggle_session_vote, params: { id: 1, vote: true }
        allow(logged_in).to receive(:add_session_vote).with(1).exactly(1).times
      end

      it "should remove vote when param is false" do
        post :toggle_session_vote, params: { id: 1, vote: false }
        allow(logged_in).to receive(:remove_session_vote).with(1).exactly(1).times
      end
    end
  end

  describe "GET session faved ids" do
    it "should list the ones for current user" do
      allow_any_instance_of(User).to receive(:session_proposal_faved_ids).and_return([1,2,3])

      get :session_proposal_faved_ids

      body = JSON.parse response.body
      expect(body.count).to eq 3
      expect(body).to eq [1,2,3]
    end
  end

  describe "POST toggle session fav" do
    context "with invalid params" do
      it { expect{ post :toggle_session_fav, params: { invalid: 1 } }.to raise_error ActionController::ParameterMissing }
    end

    context "with valid params" do
      it "should trigger toggling faved session" do
        post :toggle_session_fav, params: { id: 1 }
        allow(logged_in).to receive(:toggle_session_faved).with(1).exactly(1).times
      end
    end
  end
end
