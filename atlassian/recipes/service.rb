node[:deploy].each do |application, deploy|
  template "/etc/init.d/" + application do
    source 'atlassian_service.erb'
    owner 'root'
    group 'root'
    mode 0755
    variables(
      :application => application,
      :deploy => deploy
    )
    not_if deploy[:no_service]
  end

  service application do
    action [:enable, :start]
    not_if deploy[:no_service]
  end
end