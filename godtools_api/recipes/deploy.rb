chef_gem 'jenkins_api_client'

ruby_block 'deploy-from-jenkins' do
  require 'jenkins_api_client'

  @client = JenkinsApi::Client.new(:server_ip => node['godtools']['continuous_integration']['hostname'],
                                   :username => node['godtools']['continuous_integration']['username'],
                                   :password => node['godtools']['continuous_integration']['password'],
                                   :ssl => true,
                                   :server_port => 443)

  job_params = Hash.new()
  job_params['targetEnvironment'] = node['godtools']['continuous_integration']['target_environment']
  job_params['targetServerIP'] = node['opsworks']['instance']['private_ip']
  job_params['databaseMigration'] = node['godtools']['continuous_integration']['database_migration']
  job_params['deployerPassword'] = node['wildfly']['deploy_password']

  @client.job.build(node['godtools']['continuous_integration']['job_name'], job_params, {})

  action :nothing
end
