module ControllerHelpers
  def logged_in type, first_name=''
    user = first_name.empty? ? FactoryGirl.build(type) : FactoryGirl.build(type, first_name: first_name)
    User.find_by(email: user.email)
  end
end