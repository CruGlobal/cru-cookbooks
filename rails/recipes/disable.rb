include_recipe "deploy"

application = deploy[:application]
deploy = node[:deploy][application]

template "#{deploy[:deploy_to]}/current/system/maintenance.html" do
  source "maintenance.html.erb"
  cookbook 'rails'
  mode "0660"
  group deploy[:group]
  owner deploy[:user]
  variables(:reason => deploy[:reason], :deadline => deploy[:deadline])
end

