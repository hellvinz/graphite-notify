require 'net/http'
require 'capistrano'
require 'uri'

module Capistrano
  module Graphite
    # Called when a Capistrano::Configuration.instance exists. Will define two tasks: 
    #   * graphite:notify_deploy to notify graphite that a deploy occured with the app, the user, the stage in tags and message
    #   * graphite:notify_restart to notify graphite that a rollback occured with the app, the user, the stage in tags and message
    # @param [Capistrano::Configuration] configuration the current capistrano configuration instance
    def self.load_into(configuration)
      configuration.load do

        after "deploy:restart", "graphite:notify_deploy"
        after "rollback:restart", "graphite:notify_rollback"

        local_user = ENV['USER'] || ENV['USERNAME']

        namespace :graphite do
          desc 'notify graphite that a deployment occured'
          task :notify_deploy, :on_error => :continue do
            uri = URI::parse(graphite_url)
            http = Net::HTTP.new(uri.host, uri.port)
            if uri.scheme == 'https'
              http.use_ssl = true
            end
            http.start  do |http|
              if respond_to?(:stage)
                http.post(uri.path, "{\"what\": \"deploy #{application} in #{stage}\", \"tags\": \"#{application},#{stage},#{real_revision},deploy\", \"data\": \"#{local_user}\"}")
              else
                http.post(uri.path, "{\"what\": \"deploy #{application}\", \"tags\": \"#{application},#{real_revision},deploy\", \"data\": \"#{local_user}\"}")
              end
            end
          end

          desc 'notify graphite that a rollback occured'
          task :notify_rollback, :on_error => :continue do
            uri = URI::parse(graphite_url)
            Net::HTTP.start(uri.host, uri.port)  do |http|
              if respond_to?(:stage)
                http.post(uri.path, "{\"what\": \"rollback #{application} in #{stage}\", \"tags\": \"#{application},#{stage},#{real_revision},rollback\", \"data\": \"#{local_user}\"}")
              else
                http.post(uri.path, "{\"what\": \"rollback #{application}\", \"tags\": \"#{application},#{real_revision},rollback\", \"data\": \"#{local_user}\"}")
              end
            end
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::Graphite.load_into(Capistrano::Configuration.instance)
end
