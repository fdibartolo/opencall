class RolesController < ApplicationController
  before_action :authenticate_user!
  before_action :forbid_if_no_access

  def index
    @roles = Role.where.not(name: RoleAdmin)
  end

  def update
    user = User.find_by(email: email_param)
    if user
      role = Role.find_by(id: role_id_param)
      user.roles << role unless user.roles.include?(role)
      message = { notice: "#{email_param} was assigned succesfully"}
    else
      message = { alert: "Unable to find user with email '#{email_param}'"}
    end
    redirect_to roles_path, message
  end

  private
  def forbid_if_no_access
    raise CanCan::AccessDenied unless current_user.admin?
  end

  def role_id_param
    params.require(:id)
  end

  def email_param
    params.require(:email)
  end
end
