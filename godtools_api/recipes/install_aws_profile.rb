directory '.aws' do
  owner 'wildfly'
  group 'wildfly'
   mode 0755
   action :create
end


template '.aws/credentials' do
  owner 'wildfly'
  group 'wildfly'
  mode 0444
  source 'godtools_aws_credentials.erb'
  action :create
end