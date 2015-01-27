json.extract! @session_proposal, :id, :title, :description
json.date @session_proposal.created_at
json.author @session_proposal.user.full_name
json.tags @session_proposal.tags.map(&:name)
