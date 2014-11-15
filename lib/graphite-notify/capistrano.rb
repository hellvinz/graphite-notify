require 'net/http'
require 'capistrano'
require 'uri'
require 'json'

module Capistrano
  module Graphite
    # Called when a Capistrano::Configuration.instance exists. Will define two tasks:
    #   * graphite:notify_deploy notify graphite of an app deploy with the user in tags and a message
    #   * graphite:notify_restart notify graphite of an app rollback with the user in tags and a message
    # @param [Capistrano::Configuration] configuration the current capistrano configuration instance
    def self.load_into(configuration)
      configuration.load do

        after 'deploy:restart', 'graphite:notify_deploy'
        after 'rollback:restart', 'graphite:notify_rollback'

        local_user = ENV['USER'] || ENV['USERNAME']

        namespace :graphite do
          desc 'notify graphite that a deployment occured'
          task :notify_deploy, :on_error => :continue do
            uri = URI(graphite_url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true if uri.scheme == 'https'
            begin
              http.start  do |h|
                if respond_to?(:stage)
                  h.post(uri.path, { 'what' => "deploy #{application} in #{stage}",
                                     'tags' => "#{application},#{stage},#{real_revision},deploy",
                                     'data' => "#{local_user}" }.to_json)
                else
                  h.post(uri.path, { 'what' => "deploy #{application}",
                                     'tags' => "#{application},#{real_revision},deploy",
                                     'data' => "#{local_user}" }.to_json)
                end
              end
            rescue => e
              puts "graphite:notify_deploy failed: #{e.message}"
            end
          end

          desc 'notify graphite that a rollback occured'
          task :notify_rollback, :on_error => :continue do
            uri = URI(graphite_url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true if uri.scheme == 'https'
            begin
              http.start do |h|
                if respond_to?(:stage)
                  h.post(uri.path, { 'what' => "rollback #{application} in #{stage}",
                                     'tags' => "#{application},#{stage},#{real_revision},rollback",
                                     'data' => "#{local_user}" }.to_json)
                else
                  h.post(uri.path, { 'what' => "rollback #{application}",
                                     'tags' => "#{application},#{real_revision},rollback",
                                     'data' => "#{local_user}" }.to_json)
                end
              end
            rescue => e
              puts "graphite:notify_rollback failed: #{e.message}"
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
