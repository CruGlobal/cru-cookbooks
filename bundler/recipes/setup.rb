if node[:bundle_config]
  execute "upgrade bundler" do
    command "/usr/bin/sudo gem install bundler"
    action :run
  end

  node[:bundle_config].each do |config|
    execute "configure bundler" do
      command "/usr/bin/sudo su deploy -c 'bundle config #{config}'"
      action :run
    end
  end
end
