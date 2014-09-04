include_recipe 'deploy'

node[:deploy].each do |application, deploy|
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
