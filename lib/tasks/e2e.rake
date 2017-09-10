require 'rake'
require 'elasticsearch/extensions/test/cluster/tasks'

def overwrite_env_vars
  ENV['SUBMISSION_DUE_DATE']=(DateTime.now + 1.day).to_s
  ENV['IS_TWEET_UPON_SUBMISSION_ENABLED']='false'
  ENV['RAILS_ENV']='integration'
  ENV['PROTRACTOR_SERVER_ENV']='integration'
end

namespace :open_call do
  desc "Starts ElasticSearch and runs protractor e2e tests on integration environment"
  task :e2e do
    overwrite_env_vars()
    es_test_args = { number_of_nodes: 2, cluster_name: 'e2e_test' }

    Elasticsearch::Extensions::Test::Cluster.start(
      es_test_args.merge({ port: 9200, command: ENV['ES_TEST_BIN'] })
    ) unless Elasticsearch::Extensions::Test::Cluster.running? es_test_args

    begin
      system "rake db:setup"
      ENV["nolog"] = 'y' # avoid selenium and rails logs on stdout
      Rake::Task["protractor:spec"].invoke
    rescue Exception => e
      puts "Something went wrong: #{e.message}"
    end

    Elasticsearch::Extensions::Test::Cluster.stop(port: 9200)
  end
end
