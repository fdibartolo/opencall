host = Rails.env.test? ? "#{ENV['ES_TEST_HOST']}:#{ENV['ES_TEST_PORT']}" : ENV['SEARCHBOX_URL']
Elasticsearch::Model.client = Elasticsearch::Client.new url: host