json.array!(@results) do |session_proposal|
  json.extract! session_proposal._source, :id, :title, :description, :author, :tags
end
