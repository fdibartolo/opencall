class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_up_or_login_with "Github"
  end

  def google_oauth2
    sign_up_or_login_with "Google"
  end

  private
  def sign_up_or_login_with provider
    user = User.from_omniauth(request.env["omniauth.auth"])

    sign_in_and_redirect user, :event => :authentication
    set_flash_message(:notice, :success, :kind => provider) if is_navigational_format?
  end
end