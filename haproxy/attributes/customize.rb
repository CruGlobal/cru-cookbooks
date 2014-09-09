jira_backends = []
node[:opsworks][:layers][:jira][:instances].each do |instance, attributes|
  backend = {
    "ip" => attributes[:private_ip],
    "name" => instance,
    "backends" => attributes[:backends]
  }
  jira_backends << backend
end

default[:haproxy][:jira_backends] = jira_backends.to_json
