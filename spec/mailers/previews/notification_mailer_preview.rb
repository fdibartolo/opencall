# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def session_accepted_email
    NotificationMailer.session_accepted_email SessionProposal.first, 'Some email body text...'
  end

  def session_declined_email
    NotificationMailer.session_declined_email SessionProposal.first, 'Some email body text...'
  end

  def general_notification_email
    NotificationMailer.general_notification_email User.first.email, "Some Subject", "Some Body"
  end
end
