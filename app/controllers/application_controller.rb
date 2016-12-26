class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url + '#/error/access_denied'
  end

  protected
  def set_resource resource_type, value
    resource = eval "#{resource_type}.find_by(id: #{value})"
    eval "@#{resource_type.to_s.underscore} = resource"
    return head(:bad_request, { message: "Unable to find #{resource_type.to_s.underscore.gsub('_', ' ')} with id '#{value}'"}) unless resource
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:first_name, :last_name, :country, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :account_update, keys: [:first_name, :last_name, :country, :email, :password, :password_confirmation, :current_password, :website, :bio, :linkedin, :aboutme, :twitter, :facebook]
  end
end
