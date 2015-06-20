require 'rails_helper'

RSpec.describe Users::RegistrationsController, :type => :controller do
  login_as :user

  describe "PATCH update" do
    let(:payload) { { :user => { :bio => 'updated bio' } } }

    before :each do
      patch :update, payload
    end

    it { expect(response.location).to match edit_user_registration_path }
    it { expect(logged_in.bio).to eq 'updated bio' }
  end
end
