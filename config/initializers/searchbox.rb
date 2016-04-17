host = Rails.env.test? ? "#{ENV['ES_TEST_HOST']}:#{ENV['ES_TEST_PORT']}" : ENV['SEARCHBOX_URL']
Elasticsearch::Model.client = Elasticsearch::Client.new url: host

# create indices if they dont exist
Process.fork do
  begin
    sleep(10) # hack :(
    [SessionProposal, Tag].each do |model|
      unless Elasticsearch::Model.client.indices.exists?(index: model.index_name)
        p "creating index #{model.index_name}..."
        model.__elasticsearch__.create_index!
      end
    end
  rescue Exception
    # while deploying to Heroku for first time via rake open_call:heroku:create, the 
    # ElasticSearch addon is not yet provided
    p "The ElasticSearch cluster did not start after 10 secs, skipping indices creation"
  end
end

