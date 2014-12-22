include_recipe "deploy"

node[:deploy].each do |application, deploy|
  next unless node[:application] && node[:application] == application
  
  template "#{node[:monit][:conf_dir]}/sidekiq_#{application}.monitrc" do
    cookbook 'sidekiq'
    owner 'root'
    group 'root'
    mode 0644
    source "monitrc.conf.erb"
    variables({
      :app_name => application,
      :deploy => deploy
    })

    only_if do
      deploy[:sidekiq] && deploy[:sidekiq][:enabled] == true
    end
  end

  execute "ensure-sidekiq-is-setup-with-monit" do
    command %Q{
      monit reload
    }
  end

  execute "restart-sidekiq" do
    command "sleep 2 && monit -g sidekiq_#{application} restart all"
  end
end
