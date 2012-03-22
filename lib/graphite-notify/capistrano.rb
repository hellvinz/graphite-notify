# Just add "require 'graphite-notify/capistrano'" in your Capistrano deploy.rb, and
# Bundler will be activated after each new deployment.
require 'graphite-notify/deployment'

Capistrano::Configuration.instance(:must_exist).load do
  after "deploy:restart", "graphite:notify_deploy"
  after "rollback:restart", "graphite:notify_rollback"
  GraphiteNotify::Deployment.define_task(self, :task, :except => { :no_release => true })
end
