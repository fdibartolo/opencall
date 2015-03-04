class ApplicationMailer < ActionMailer::Base
  default from: MailerAccount
  layout 'mailer'
end
