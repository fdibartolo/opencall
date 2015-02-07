host = Rails.env.test? ? "#{ENV['ES_TEST_HOST']}:#{ENV['ES_TEST_PORT']}" : ENV['BONSAI_URL']
Elasticsearch::Model.client = Elasticsearch::Client.new url: host