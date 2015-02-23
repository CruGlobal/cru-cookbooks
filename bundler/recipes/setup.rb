if node[:bundle_config]
  node[:bundle_config].each do |config|
    execute "configure bundler" do
      command "/usr/bin/sudo su deploy -c 'bundle config #{config}'"
      action :run
    end
  end
end
