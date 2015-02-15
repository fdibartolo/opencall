module ControllerHelpers
  def logged_in type
    user = FactoryGirl.build(type)
    User.find_by(email: user.email)
  end
end