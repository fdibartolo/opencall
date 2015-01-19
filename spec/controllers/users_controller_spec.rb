require 'rails_helper'

RSpec.describe Users::UsersController, :type => :controller do
  login_user

  describe "GET reset_password" do
    subject { get :reset_password }

    it "should set token and redirect to default devise form" do
      expect_any_instance_of(User).to receive(:save).twice.and_return(true) # sign_out also calls save on user :S
      expect(subject.location).to include edit_user_password_path(reset_password_token: nil)
    end
  end
end
