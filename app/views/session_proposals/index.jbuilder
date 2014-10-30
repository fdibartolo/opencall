json.array!(@session_proposals) do |session_proposal|
  json.extract! session_proposal, :id, :author, :title, :description
end
