require 'rake'
require 'elasticsearch/extensions/test/cluster/tasks'

def overwrite_env_vars
  ENV['SUBMISSION_DUE_DATE']=(DateTime.now + 1.day).to_s
  ENV['IS_TWEET_UPON_SUBMISSION_ENABLED']='false'
end

namespace :open_call do
  desc "Starts ElasticSearch on test port (ES_TEST_PORT) and runs protractor e2e tests"
  task :e2e do
    overwrite_env_vars()
    es_test_args = { number_of_nodes: 2, cluster_name: 'e2e_test' }

    Elasticsearch::Extensions::Test::Cluster.start(
      es_test_args.merge({ port: ENV['ES_TEST_PORT'], command: ENV['ES_TEST_BIN'] })
    ) unless Elasticsearch::Extensions::Test::Cluster.running? es_test_args

    begin
      Rake::Task["protractor:cleanup"].invoke # drop, create and seed for current run of e2e tests
      ENV["nolog"] = 'y' # avoid selenium and rails logs on stdout
      Rake::Task["protractor:spec"].invoke
    rescue Exception => e
      puts "Something went wrong: #{e.message}"
    ensure
      Rake::Task["db:test:prepare"].invoke # drop and create emtpy for next run of unit tests
    end

    Elasticsearch::Extensions::Test::Cluster.stop(port: ENV['ES_TEST_PORT'])
  end
end
