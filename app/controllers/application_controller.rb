class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def reset_password
    raw, enc = Devise.token_generator.generate(current_user.class, :reset_password_token)

    current_user.reset_password_token   = enc
    current_user.reset_password_sent_at = Time.now.utc
    current_user.save(validate: false)

    sign_out current_user

    redirect_to edit_user_password_path(reset_password_token: raw)
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :country, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :country, :email, :password, :password_confirmation, :current_password, :website, :bio) }
  end
end
