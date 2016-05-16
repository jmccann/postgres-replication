resource_name :postgresql_user

property :name, String
property :replication, [TrueClass, FalseClass], default: false
property :connection_limit, Integer
property :password, String, required: true

action :create do
  cmd = ["createuser -U postgres #{new_resource.name}"]
  cmd << "-c #{new_resource.connection_limit}" if new_resource.connection_limit
  cmd << '--replication' if new_resource.replication

  execute 'create user' do
    user 'postgres'
    command cmd.join(' ')
    not_if "psql postgres -tAc \"SELECT 1 FROM pg_roles WHERE rolname='#{new_resource.name}'\" | grep -q 1"
    notifies :run, 'execute[set password]', :immediately
  end

  execute 'set password' do
    user 'postgres'
    command "psql -U postgres -c \"alter user \\\"#{new_resource.name}\\\" with password '#{new_resource.password}';\""
    action :nothing
    sensitive true
  end
end
