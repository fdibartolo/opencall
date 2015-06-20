class NotificationMailer < ApplicationMailer
  def session_accepted_email session_proposal
    @user = session_proposal.user
    @session_proposal = session_proposal
    mail to: @user.email, bcc: administrators
  end

  def session_declined_email session_proposal
    @user = session_proposal.user
    @session_proposal = session_proposal
    mail to: @user.email, bcc: administrators
  end

  def general_notification_email(email, subject, body)
    @body = body
    mail to: email, subject: subject
  end

  private
  def administrators
    Role.find_by(name: RoleAdmin).users.pluck(:email)
  end
end
