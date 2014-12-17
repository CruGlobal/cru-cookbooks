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

include_recipe "nginx::service"

line1 = '#add headers if index.html'
line2 = 'if ($request_uri = "/") {'
line3 = 'add_header Cache-Control "no-cache, no-store, must-revalidate";'
line4 = '}'


ruby_block "insert_line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/nginx/sites-available/crs_web")
    file.insert_line_after_match("index.php", " #{line4}")
    file.insert_line_after_match("index.php", " #{line3}")
    file.insert_line_after_match("index.php", " #{line2}")
    file.insert_line_after_match("index.php", " #{line1}")
    file.insert_line_after_match("index.php", " ")
    file.write_file
  end
notifies :restart, "service[nginx]", :immediately
not_if "grep -q #{line1} /etc/nginx/sites-available/crs_web"
end

ruby_block "insert_line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/nginx/sites-available/eventhub")
    file.insert_line_after_match("index.php", " #{line4}")
    file.insert_line_after_match("index.php", " #{line3}")
    file.insert_line_after_match("index.php", " #{line2}")
    file.insert_line_after_match("index.php", " #{line1}")
    file.insert_line_after_match("index.php", " ")
    file.write_file
  end
notifies :restart, "service[nginx]", :immediately
not_if "grep -q #{line1} /etc/nginx/sites-available/eventhub"
end


