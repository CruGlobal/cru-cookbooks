execute "set asynchronous enabled variable" do
  command "export ERT_ASYNC_ENABLED=true"
  action :run
end