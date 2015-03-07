include_recipe "deploy"

application = deploy[:application]
deploy = node[:deploy][application]

file "#{deploy[:deploy_to]}/current/system/maintenance.html" do
  action :delete
end
