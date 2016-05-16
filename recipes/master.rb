node.default['postgresql']['config']['wal_level'] = 'hot_standby'
node.default['postgresql']['config']['archive_mode'] = 'on'
node.default['postgresql']['config']['archive_command'] = 'test ! -f /mnt/server/archivedir/%f && cp %p /mnt/server/archivedir/%f'
node.default['postgresql']['config']['max_wal_senders'] = 3

include_recipe 'chef-vault::default'
node.set_unless['postgresql']['password']['postgres'] = chef_vault_item(node['postgres-replication']['vault'], 'postgres')['postgres']

include_recipe 'postgresql::server'

include_recipe 'postgres-replication::_delete_node_secrets'

postgresql_user 'repuser' do
  replication true
  connection_limit 5
  password chef_vault_item(node['postgres-replication']['vault'], 'repuser')['repuser']
end

directory node['postgres-replication']['archive_dir'] do
  owner 'postgres'
  group 'postgres'
  recursive true
end
