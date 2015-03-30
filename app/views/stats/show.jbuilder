json.extract! @theme, :name
json.proposals @theme.session_proposals do |session_proposal|
  json.title session_proposal.title
  json.reviews session_proposal.reviews.map(&:score)
end
