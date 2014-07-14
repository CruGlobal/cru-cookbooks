###
# This is the place to override the passenger_apache2 cookbook's default attributes.
###

# The following shows how to override the Passenger pool size and lower the idle time:
#
#normal[:passenger][:pool_idle_time] = 3600
#normal[:passenger][:max_pool_size] = 16
case node[:opsworks][:ruby_version]
when /^2\.0/
  normal[:passenger][:gems_path] = '/usr/local/lib/ruby/gems/2.0.0/gems'
when /^2\.1/
  normal[:passenger][:gems_path] = '/usr/local/lib/ruby/gems/2.1.0/gems'
end

normal[:passenger][:root_path] = "#{normal[:passenger][:gems_path]}/passenger-enterprise-server-#{passenger[:version]}"
