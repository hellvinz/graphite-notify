require 'rubygems'
require 'webmock/rspec'
require 'capistrano-spec'

RSpec.configure do |config|
  config.include Capistrano::Spec::Matchers
  config.include Capistrano::Spec::Helpers
  config.mock_with :rspec
  config.expect_with :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
