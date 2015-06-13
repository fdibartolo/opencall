module ControllerHelpers
  def logged_in
    User.find_by(email: @logged_user.email)
  end
end