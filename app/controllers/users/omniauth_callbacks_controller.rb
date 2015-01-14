class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
    redirect_to root_path
  end
end