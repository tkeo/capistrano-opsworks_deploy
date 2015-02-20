require 'aws-sdk-core'
require 'terminal-table'

namespace :opsworks do
  set :opsworks_region, 'us-east-1'

  desc 'deploy using OpsWorks API'
  task :deploy do
    set :opsworks_command_name, 'deploy'
    invoke 'opsworks:deploy:starting'
    invoke 'opsworks:create_deployment'
    invoke 'opsworks:wait_for_status_change'
    invoke 'opsworks:deploy:finished'
  end

  task :execute_recipes do
    set :opsworks_command_name, 'execute_recipes'
    set :opsworks_command_args, { recipes: Array(fetch(:opsworks_recipes)) }
    invoke 'opsworks:create_deployment'
    invoke 'opsworks:wait_for_status_change'
  end

  namespace :deploy do
    desc 'deploy and migrate using OpsWorks API'
    task :migrate do
      set :opsworks_command_name, 'deploy'
      set :opsworks_command_args, { migrate: ['true'] }
      invoke 'opsworks:deploy'
    end

    desc 'rollback the last deploy'
    task :rollback do
      set :opsworks_command_name, 'rollback'
      invoke 'opsworks:deploy:rollback:starting'
      invoke 'opsworks:create_deployment'
      invoke 'opsworks:wait_for_status_change'
      invoke 'opsworks:deploy:rollback:finished'
    end

    namespace :rollback do
      task :starting
      task :finished
    end

    desc 'show deploy history'
    task :history do
      client = Aws::OpsWorks::Client.new(region: fetch(:opsworks_region))
      response = client.describe_deployments(app_id: fetch(:opsworks_app_id))
      table = Terminal::Table.new(headings: %w(created_at command args status)) do |t|
        response.deployments.each do |d|
          t << [d.created_at, d.command.name, d.command.args.to_s, d.status]
        end
      end
      puts table
    end

    task :starting
    task :finished
  end

  task :create_deployment do
    options = {
      stack_id: fetch(:opsworks_stack_id),
      app_id: fetch(:opsworks_app_id),
      instance_ids: fetch(:opsworks_instance_ids),
      command: { name: fetch(:opsworks_command_name), args: fetch(:opsworks_command_args) },
    }
    if custom_json = fetch(:opsworks_custom_json, nil)
      options[:custom_json] = custom_json
    end
    client = Aws::OpsWorks::Client.new(region: fetch(:opsworks_region))
    response = client.create_deployment(options)
    deployment_id = response.deployment_id
    puts "start #{fetch(:opsworks_command_name)} (deployment_id: #{deployment_id})"
    set :opsworks_deployment_id, deployment_id
  end

  task :wait_for_status_change do
    client = Aws::OpsWorks::Client.new(region: fetch(:opsworks_region))
    loop do
      print '.'
      sleep 30

      response = client.describe_deployments(deployment_ids: [fetch(:opsworks_deployment_id)])
      deployment = response.first.deployments.first

      case deployment.status
      when 'running'
        next
      when 'successful'
        break
      else
        raise deployment.status
      end
    end
    puts "\n#{fetch(:opsworks_command_name)} successfully finished."
  end
end
