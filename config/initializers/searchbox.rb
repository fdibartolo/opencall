host = Rails.env.test? ? "#{ENV['ES_TEST_HOST']}:#{ENV['ES_TEST_PORT']}" : ENV['SEARCHBOX_URL']
Elasticsearch::Model.client = Elasticsearch::Client.new url: host

# create indices if they dont exist
Process.fork do
  sleep(10) # hack :(
  [SessionProposal, Tag].each do |model|
    unless Elasticsearch::Model.client.indices.exists?(index: model.index_name)
      p "creating index #{model.index_name}..."
      model.__elasticsearch__.create_index!
    end
  end
end
