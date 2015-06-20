module ControllerMacros
  def login_as type, first_name=''
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @logged_user = first_name.empty? ? FactoryGirl.create(type) : FactoryGirl.create(type, first_name: first_name)
      # user.confirm!
      sign_in @logged_user
    end
  end
end