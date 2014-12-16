#
# Cookbook Name:: nginx
# Recipe:: config
# Author:: luis Rodriguez  <luis.rodriguez@cru.org>
#
# Copyright 2008, OpsCode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "nginx"


include_recipe "nginx::service"

template "#{node[:nginx][:dir]}/sites-available/crs_web_test" do
  source "site.erb"
  owner "root"
  group "root"
  mode 0644
notifies :restart, "service[nginx]", :immediately
only_if !File.exist?("#{node[:nginx][:dir]}/sites-available/crs_web_test") }
end


