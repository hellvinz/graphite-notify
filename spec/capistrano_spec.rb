require 'spec_helper'

require './lib/graphite-notify/capistrano'

describe Capistrano::Graphite, "loaded into a configuration" do
  before do
    ENV['USER'] = 'testuser'
    @configuration = Capistrano::Configuration.new
    @configuration.set :graphite_url, 'http://localhost/'
    @configuration.set :application, 'testapp'
    @configuration.set :real_revision, 'randomsha'
    Capistrano::Graphite.load_into(@configuration)
  end

  it 'should define callbacks' do
    @configuration.should callback('graphite:notify_deploy').after('deploy:restart')
    @configuration.should callback('graphite:notify_rollback').after('deploy:rollback')
  end

  context 'without capistrano-multistage support' do
    it 'should notify graphite of a deploy' do
      stub_request(:post, "http://localhost/").
           with(:body => {"data"=>"testuser", "tags"=>"testapp,randomsha,deploy", "what"=>"deploy testapp"},
                :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
           to_return(:status => 200, :body => "", :headers => {})
      @configuration.find_and_execute_task('graphite:notify_deploy')

    end

    it 'should notify graphite of a rollback' do
      stub_request(:post, "http://localhost/").
           with(:body => {"data"=>"testuser", "tags"=>"testapp,randomsha,rollback", "what"=>"rollback testapp"},
                :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
           to_return(:status => 200, :body => "", :headers => {})
      @configuration.find_and_execute_task('graphite:notify_rollback')
    end
  end

  context 'with capistrano-multistage support' do
    before do
      @configuration.set :stage, 'test'
    end
    it 'should notify graphite of a deploy' do
      stub_request(:post, "http://localhost/").
           with(:body => {"data"=>"testuser", "tags"=>"testapp,test,randomsha,deploy", "what"=>"deploy testapp in test"},
                :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
           to_return(:status => 200, :body => "", :headers => {})
      @configuration.find_and_execute_task('graphite:notify_deploy')

    end

    it 'should notify graphite of a rollback' do
      stub_request(:post, "http://localhost/").
           with(:body => {"data"=>"testuser", "tags"=>"testapp,test,randomsha,rollback", "what"=>"rollback testapp in test"},
                :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
           to_return(:status => 200, :body => "", :headers => {})
      @configuration.find_and_execute_task('graphite:notify_rollback')
    end
  end
end
