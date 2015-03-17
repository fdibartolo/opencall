json.total @results.total
json.sessions @results do |session_proposal|
  json.extract! session_proposal._source, :id, :title, :theme, :track, :author, :tags
end
json.matched_tags @matched_tags
