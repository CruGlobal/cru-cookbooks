execute "add user" do
  user "root"
  command '/opt/wildfly/bin/add-user.sh --silent ' + node['wildfly']['deploy_username'] + ' ' + node['wildfly']['deploy_password']
  # there isn't an obvious way to see if a user already exists or not in wildfly.. so this command may just run and fail.  we'll see.
end