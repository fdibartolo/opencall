json.array!(@session_proposals) do |session_proposal|
  json.extract! session_proposal, :id
  json.url session_proposal_url(session_proposal, format: :json)
end
