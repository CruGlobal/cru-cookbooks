# generate cert files for ssl termination
directory '/etc/haproxy/certs.d' do
  owner "root"
  group "root"
  mode 0755
  action :create
end

haproxy = node['haproxy']
app_names = []
%w(rails_applications php_applications nodejs_applications java_applications static_applications).each do |layer|
  app_names += haproxy[layer].keys if haproxy[layer]
end
app_names.each do |app_name|
  app = node['deploy'][app_name]
  if app && app['ssl_support']
    app['domains'].each do |domain|
      template "/etc/haproxy/certs.d/#{domain}.pem" do
        cookbook "haproxy"
        source "cert.pem.erb"
        owner "root"
        group "root"
        mode 0644
        variables(:app => app)
      end
    end
  end
end

service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action :nothing # only define so that it can be restarted if the config changed
end

template "/etc/haproxy/haproxy.cfg" do
  cookbook "haproxy"
  source "haproxy.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[haproxy]"
end

execute "echo 'checking if HAProxy is not running - if so start it'" do
  not_if "pgrep haproxy"
  notifies :start, "service[haproxy]"
end

