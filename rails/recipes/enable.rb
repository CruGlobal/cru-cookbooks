application = node['application']

file "/srv/www/#{application}/current/public/system/maintenance.html" do
  action :delete
end
