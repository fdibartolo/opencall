json.extract! @session_proposal, :id, :title, :description
json.tags @session_proposal.tags.map(&:name)
