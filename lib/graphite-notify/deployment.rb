module Bundler
  class Deployment
    def self.define_task(context, task_method = :task, opts = {})
      if defined?(Capistrano) && context.is_a?(Capistrano::Configuration)
        context_name = "capistrano"
        role_default = "{:except => {:no_release => true}}"
        error_type = ::Capistrano::CommandError
      end

      graphite_url = context.fetch(:graphite_url, false)
      raise "Missing graphite_url" unless graphite_url

      context.send :namespace, :graphite do
        send :desc, <<-DESC
          notify graphite that a deployment occured
        DESC
        send task_method, :notify_deploy, :on_error => :continue do
          `curl -s -X POST #{graphite_url} -d '{"what": "deploy #{application} in #{environment}", "tags": "#{application},#{environment},#{real_revision},deploy"}'`
        end
        send :desc, <<-DESC
          notify graphite that a rollback occured
        DESC
        send task_method, :notify_rollback, :on_error => :continue do
          `curl -s -X POST #{graphite_url} -d '{"what": "rollback #{application} in #{environment}", "tags": "#{application},#{environment},#{real_revision},rollback"}'`
        end
      end
    end
  end
end
