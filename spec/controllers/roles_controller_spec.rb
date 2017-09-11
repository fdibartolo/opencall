require 'rails_helper'

RSpec.describe RolesController, type: :controller do
  login_as :admin

  describe "GET #index" do
    before :each do
      get :index
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "should assign roles variable" do
      expect(assigns(:roles)).to_not be_nil
    end

    it "should not include 'admin' role" do
      expect(assigns(:roles)).to_not include Role.find_by(name: RoleAdmin)
    end
  end

  describe "PATCH #update" do
    context "with invalid params" do
      it { expect{ patch :update, params: { id: 1, missing_email: 'email' } }.to raise_error ActionController::ParameterMissing }
    end

    context "with valid params" do
      let(:user) { FactoryGirl.create :user, first_name: 'Bob' }
      let(:role) { FactoryGirl.create :role, name: RoleReviewer }

      it "should assign role to given user" do
        patch :update, params: { id: role.id, email: user.email }
        expect(user.roles).to include role
      end

      it "should fire email to given user" do
        patch :update, params: { id: role.id, email: user.email }
        email = ActionMailer::Base.deliveries.last
        expect(email.subject).to eq I18n.t('role_mailer.role_created_email.subject')
      end

      it "should not assign role if alredy present" do
        user.roles << role
        patch :update, params: { id: role.id, email: user.email }
        expect(user.roles.count).to eq 1
      end
    end
  end

  describe "DELETE #destroy" do
    context "with invalid params" do
      it { expect{ delete :destroy, params: { id: 1, missing_user_id: '1' } }.to raise_error ActionController::ParameterMissing }
    end

    context "with valid params" do
      let(:user) { FactoryGirl.create :user, first_name: 'Bob' }
      let(:role) { FactoryGirl.create :role, name: RoleReviewer }

      it "should remove role to given user" do
        user.roles << role
        delete :destroy, params: { id: role.id, user_id: user.id }
        expect(user.reload.roles).to_not include role
      end
    end
  end
end
