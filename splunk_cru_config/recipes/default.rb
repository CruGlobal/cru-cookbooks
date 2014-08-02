
# Cookbook Name:: splunk_cru_config
# Recipe:: default
#

#

#
#configure splunk
bash 'splunk_conf' do
  if !File.exists?("#{node['splunk']['install_path']}/etc/apps/search/local/inputs.conf")
    code <<-EOH
    cd "#{node['splunk']['install_path']}/bin"
    ./splunk start --accept-license
    ./splunk enable boot-start
    ./splunk add forward-server #{node['splunk']['forward_server']}:#{node['splunk']['receiver_port']} -auth #{node['splunk']['auth']}:#{node['splunk']['pass']}
    ./splunk add monitor #{node['splunk']['monitor_path']}
    ./splunk edit user #{node['splunk']['auth']} -password #{node['splunk']['newpass']} -auth #{node['splunk']['auth']}:#{node['splunk']['pass']}
    ./splunk restart
    EOH
  end
end
