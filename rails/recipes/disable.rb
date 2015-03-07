application = node['application']

template "/srv/www/#{application}/current/system/maintenance.html" do
  source "maintenance.html.erb"
  cookbook 'rails'
  mode "0660"
  group deploy[:group]
  owner deploy[:user]
  variables(:reason => node[:reason], :deadline => node[:deadline])
end

