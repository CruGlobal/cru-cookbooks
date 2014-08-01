
# Cookbook Name:: splunk_cru_config
# Recipe:: default
#
# Copyright 2014, cru
#
# All rights reserved - Do Not Redistribute
#

#configure splunk
bash 'splunk_conf' do
  if !File.exists?("#{node['splunk']['install_path']}/etc/apps/search/local/inputs.conf")
    code <<-EOH
    cd "#{node['splunk']['install_path']}/bin"
    ./splunk start --accept-license
    ./splunk enable boot-start
    ./splunk add forward-server ulspla01.ccci.org:9997 -auth admin:changeme
    ./splunk add monitor  /opt/wildfly-8.1.0.Final/standalone/log/server.log
    ./splunk restart
    EOH
  end
end
