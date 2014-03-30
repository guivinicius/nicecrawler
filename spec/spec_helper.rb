require 'simplecov'
require 'webmock/rspec'

SimpleCov.start

require 'nice_crawler'
require 'support/page_mock'

include Mongo

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.order = 'random'

  config.after(:each) do
    db = MongoClient.new.db('nicecrawler')
    db.collection('sitemaps').remove
  end
end
