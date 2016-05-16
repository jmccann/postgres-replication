node.default['postgresql']['config']['hot_standby'] = 'on'

include_recipe 'chef-vault::default'
node.set_unless['postgresql']['password']['postgres'] = chef_vault_item(node['postgres-replication']['vault'], 'postgres')['postgres']

include_recipe 'postgresql::server'

include_recipe 'postgres-replication::_delete_node_secrets'

execute 'rename original main' do
  command "mv /var/lib/postgresql/#{node['postgresql']['version']}/main /var/lib/postgresql/9.3/main_old"
  creates "/var/lib/postgresql/#{node['postgresql']['version']}/main_old"
end

postgresql_backup 'from master' do
  ip node['postgres-replication']['master']['ip']
  directory "/var/lib/postgresql/#{node['postgresql']['version']}/main"
  user 'repuser'
  password chef_vault_item(node['postgres-replication']['vault'], 'repuser')['repuser']
  xlog_method 'stream'
  verbose true
  not_if "[ -d /var/lib/postgresql/#{node['postgresql']['version']}/main ]"
end

template "#{node['postgresql']['config']['data_directory']}/recovery.conf" do
  owner 'postgres'
  group 'postgres'
  mode '0600'
  variables host: node['postgres-replication']['master']['ip'], password: chef_vault_item(node['postgres-replication']['vault'], 'repuser')['repuser']
  notifies :restart, 'service[postgresql]', :immediately
end
