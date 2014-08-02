# Cookbook Name:: splunk_cru_config
# Recipe:: default

#configure splunk
fw_server = #node{['splunk']['forward_server']}
auth_user = #node{['splunk']['auth']}
default_pass = #node{['splunk']['pass']}
new_pass = #node{['splunk']['newpass']}

bash 'splunk_conf' do
  if !File.exists?("#{node['splunk']['install_path']}/etc/apps/search/local/inputs.conf")
    code <<-EOH
    cd "#{node['splunk']['install_path']}/bin"
    ./splunk start --accept-license
    ./splunk enable boot-start
    ./splunk add forward-server #{fw_server}:9997 -auth #{auth_user}:#{default_pass}
    ./splunk add monitor #{node['splunk']['monitor_path']}
    ./splunk edit user #{auth_user} -password #{new_pass} -auth #{auth_user}:#{new_pass}
    ./splunk restart
    EOH
  end
end
