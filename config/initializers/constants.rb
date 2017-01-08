SiteTitle = "Agiles 2016 | Call for Papers"

# UIFaces is temporarily down =(
# DefaultAvatarUrl = "https://s3.amazonaws.com/uifaces/faces/twitter/cbillins/73.jpg" 
DefaultAvatarUrl = "https://pickaface.net/gallery/avatar/unr_dennis67_161116_2059_9mwjh9.png"

RoleAdmin     = 'admin'
RoleReviewer  = 'reviewer'

MaxSessionProposalVotes = 10

MailerAccount = "Sesiones Agiles <comunidad@agileecuador.org>"
ChairsAccount = "comunidad@agileecuador.org"
TwitterAccount = "opencall_cfp"

SubmissionDueDate = DateTime.parse(ENV['SUBMISSION_DUE_DATE'] ||(DateTime.now + 1.day).to_s) # as is until we update the system to support multi-event
AcceptanceDueDate = DateTime.parse(ENV['ACCEPTANCE_DUE_DATE'] ||(DateTime.now + 1.day).to_s) # as is until we update the system to support multi-event

Version = "1.0.11"
