json.array!(@session_proposals) do |session_proposal|
  json.extract! session_proposal, :id, :title, :description
  json.author session_proposal.user.full_name
end
