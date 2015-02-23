execute "upgrade bundler" do
  command "/usr/bin/sudo gem install bundler -v #{node[:opsworks_bundler][:version]}"
  action :run
end
