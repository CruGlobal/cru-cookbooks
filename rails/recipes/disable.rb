application = node['application']
deploy = node['deploy']
deploy_to = "/srv/www/#{application}/current/public/system"

directory deploy_to do
  action :create
  recursive true
  mode "0775"
  group deploy[:group]
  owner deploy[:user]
end

template "#{deploy_to}/maintenance.html" do
  source "maintenance.html.erb"
  cookbook 'rails'
  mode "0660"
  group deploy[:group]
  owner deploy[:user]
  variables(:reason => node[:reason], :deadline => node[:deadline])
end

