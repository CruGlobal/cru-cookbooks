include_recipe "deploy"

node[:deploy].each do |application, deploy|
  next unless deploy[:application] && deploy[:application] == application

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    only_if { ::File.exists?(deploy[:current_path]) }
    action :nothing
  end

  node.default[:deploy][application][:database][:adapter] = OpsWorks::RailsConfiguration.determine_database_adapter(application, node[:deploy][application], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
  deploy = node[:deploy][application]

  directory "#{deploy[:deploy_to]}" do
    action :create
    recursive true
    mode "0775"
    group deploy[:group]
    owner deploy[:user]
  end

  directory "#{deploy[:deploy_to]}/shared" do
    action :create
    recursive true
    mode "0775"
    group deploy[:group]
    owner deploy[:user]
  end

  directory "#{deploy[:deploy_to]}/shared/config" do
    action :create
    recursive true
    mode "0775"
    group deploy[:group]
    owner deploy[:user]
  end

  directory "#{deploy[:deploy_to]}/shared/config/initializers" do
    action :create
    recursive true
    mode "0775"
    group deploy[:group]
    owner deploy[:user]
  end

  template "#{deploy[:deploy_to]}/shared/config/mongoid.yml" do
    source "mongoid.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:mongoid => deploy[:mongoid], :environment => deploy[:rails_env])

    only_if do
      deploy[:mongoid]
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/facebook.yml" do
    source "facebook.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:facebook => deploy[:facebook], :environment => deploy[:rails_env])

    only_if do
      deploy[:facebook]
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/database.yml" do
    source "database.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:database => deploy[:database], :uscm => deploy[:uscm], :simpd => deploy[:simpd], :environment => deploy[:rails_env])

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:database][:host]
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/redis.yml" do
    source "redis.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:redis => deploy[:redis], :environment => deploy[:rails_env])

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:redis] && deploy[:redis][:host]
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/memcached.yml" do
    source "memcached.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(
      :memcached => deploy[:memcached] || {},
      :environment => deploy[:rails_env]
    )

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:memcached] && deploy[:memcached][:host]
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/sidekiq.yml" do
    source "sidekiq.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(
      :sidekiq => deploy[:sidekiq] || {},
      :environment => deploy[:rails_env]
    )

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:sidekiq] && deploy[:sidekiq][:enabled]
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/config.yml" do
    source "config.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:config => deploy[:config], :environment => deploy[:rails_env])

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:config]
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/amazon_s3.yml" do
    source "amazon_s3.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:s3 => deploy[:s3], :environment => deploy[:rails_env])

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:s3]
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/secrets.yml" do
    source "secrets.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:secrets => deploy[:secrets], :environment => deploy[:rails_env])

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:secrets]
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/smtp.rb" do
    source "smtp.rb.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:smtp => deploy[:smtp] || {}, :environment => deploy[:rails_env])

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:smtp]
    end

  end

  template "#{deploy[:deploy_to]}/shared/config/settings.local.yml" do
    source "settings.local.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:secrets => deploy[:secrets], :environment => deploy[:rails_env])

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:secrets]
    end

  end

  template "#{deploy[:deploy_to]}/shared/config/newrelic.yml" do
    source "newrelic.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:newrelic => deploy[:newrelic], :environment => deploy[:rails_env])

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:newrelic]
    end

  end

end
