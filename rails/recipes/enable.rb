application = node['application']

file "/srv/www/#{application}/current/system/maintenance.html" do
  action :delete
end
