module ControllerMacros
  def login_as type
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(type)
      # user.confirm!
      sign_in user
    end
  end
end