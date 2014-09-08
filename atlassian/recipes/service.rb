node[:deploy].each do |application, deploy|
  template "/etc/init.d/" + application do
    source atlassian_service.erb
    owner 'root'
    group 'root'
    mode 0755
    variables(
      :application => application,
      :deploy => deploy
    )
  end

  service application do
    action :enable, :start
  end
end