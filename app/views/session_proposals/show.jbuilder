json.extract! @session_proposal, :id, :title, :description
json.author @session_proposal.user.email
