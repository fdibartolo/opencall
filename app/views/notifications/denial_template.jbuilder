json.template I18n.t('notification_mailer.session_declined_email.body', 
  user: @session_proposal.user.full_name, 
  title: @session_proposal.title,
  email: ChairsAccount)
json.feedback @session_proposal.reviews.map(&:body)