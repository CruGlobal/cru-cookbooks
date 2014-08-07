include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  next if node[:current_app] && node[:current_app] != application

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping deploy::rails application #{application} as it is not a Rails app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_atlassian do
    deploy_data deploy
    app application
  end

  if deploy[:use_git]
    opsworks_deploy do
      deploy_data deploy
      app application
    end
  end
end
