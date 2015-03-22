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
      RoleMailer.role_created_email(user, role.name).deliver_now
      message = { notice: I18n.t('flash.role_assign_ok', email: email_param) }
    else
      message = { alert: I18n.t('flash.role_assign_error', email: email_param) }
    end
    redirect_to roles_path, message
  end

  def destroy
    user = User.find_by(id: user_id_param)
    if user
      user.roles.delete Role.find_by(id: role_id_param)
      message = { notice: I18n.t('flash.role_revoke_ok') }
    else
      message = { alert: I18n.t('flash.role_revoke_error') }
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

  def user_id_param
    params.require(:user_id)
  end
end
