class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url + '#/error/access_denied'
  end

  protected
  def set_session_proposal
    set_resource SessionProposal, :session_proposal_id
  end

  def set_resource resource_type, param_key
    resource = eval "#{resource_type}.find_by(id: #{params[param_key]})"
    eval "@#{resource_type.to_s.underscore} = resource"
    return head(:bad_request, { message: "Unable to find #{resource_type.to_s.underscore.gsub('_', ' ')} with id '#{params[param_key]}'"}) unless resource
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :country, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :country, :email, :password, :password_confirmation, :current_password, :website, :bio, :linkedin, :aboutme, :twitter, :facebook) }
  end
end
