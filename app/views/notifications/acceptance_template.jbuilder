json.template I18n.t('notification_mailer.session_accepted_email.body', 
  user: @session_proposal.user.full_name, 
  title: @session_proposal.title,
  acceptance_due_date: AcceptanceDueDate.strftime('%H:%Mhs of %B %d, %Y (Uruguay time - UTC-0300)'),
  email: ChairsAccount)
json.feedback @session_proposal.reviews.map(&:body)