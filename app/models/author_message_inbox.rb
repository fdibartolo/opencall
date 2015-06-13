class AuthorMessageInbox

  def message_all(subject, body)
      all_authors.each do |author|
        send_message(author, subject, body)
      end
  end

  private

  def all_authors
    User.select(&:author?)
  end

  def send_message(author, subject, body)
    NotificationMailer.general_notification_email(author.email, subject, body).deliver_now
  end
end