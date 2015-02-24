require 'rake'
require 'elasticsearch/extensions/test/cluster/tasks'

namespace :open_call do
  desc "Starts ElasticSearch on test port (ES_TEST_PORT) and runs protractor e2e tests"
  task :e2e do
    # system "ps aux | grep -ie 'elasticsearch' | grep -v grep | awk '{print $2}' | xargs kill -9" 

    Elasticsearch::Extensions::Test::Cluster.start(port: ENV['ES_TEST_PORT'], nodes: 1) unless
      Elasticsearch::Extensions::Test::Cluster.running?

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
