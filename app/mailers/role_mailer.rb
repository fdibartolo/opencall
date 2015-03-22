class RoleMailer < ApplicationMailer
  def role_created_email user, role_name
    @user = user
    @role_name = role_name
    mail to: @user.email
  end
end
