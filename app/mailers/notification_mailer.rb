class NotificationMailer < ApplicationMailer
  def session_accepted_email session_proposal, body
    @user = session_proposal.user
    @body = body
    mail to: @user.email, bcc: 'sesiones2015@agiles.org'
  end

  def session_declined_email session_proposal, body
    @user = session_proposal.user
    @body = body
    mail to: @user.email, bcc: 'sesiones2015@agiles.org'
  end

  def general_notification_email email, subject, body
    @body = body
    mail to: email, subject: subject
  end

  private
  def administrators
    Role.find_by(name: RoleAdmin).users.pluck(:email) if Role.find_by(name: RoleAdmin)
  end
end
