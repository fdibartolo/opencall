json.sessions @results do |session_proposal|
  json.extract! session_proposal._source, :id, :title, :description, :author, :tags
end
json.matched_tags @matched_tags
