json.themes @themes do |theme|
  json.extract! theme, :id, :name
  json.count theme.session_proposals.count
  json.reviewed theme.session_proposals.select{|e| e.reviews.count > 0}.count
end
