include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  resque_config

  execute "restart resque for #{application}" do
    cwd deploy[:current_path]
    command "bluepill restart resque"
    action :nothing
  end

end