DefaultAvatarUrl = "https://s3.amazonaws.com/uifaces/faces/twitter/cbillins/73.jpg"

RoleAdmin     = 'admin'
RoleReviewer  = 'reviewer'

MaxSessionProposalVotes = 10

MailerAccount = "Sesiones Agiles 2015 <sesiones@agiles.org>"
ChairsAccount = "sesiones2015@agiles.org"

SubmissionDueDate = DateTime.parse(ENV['SUBMISSION_DUE_DATE'] ||(DateTime.now + 1.day).to_s) # as is until we update the system to support multi-event
AcceptanceDueDate = DateTime.parse(ENV['ACCEPTANCE_DUE_DATE'] ||(DateTime.now + 1.day).to_s) # as is until we update the system to support multi-event

Version = "1.0.11"
