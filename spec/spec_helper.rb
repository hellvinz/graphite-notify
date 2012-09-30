require 'webmock/rspec'
require 'capistrano-spec'

Spec::Runner.configure do |config|
  config.include Capistrano::Spec::Matchers
  config.include Capistrano::Spec::Helpers
end
