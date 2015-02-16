require 'rails_helper'

RSpec.describe Users::RegistrationsController, :type => :controller do
  login_as :user

  describe "PATCH update" do
    it "should stay in user profile page" do
      expect(patch :update).to render_template(:edit)
    end
  end
end
