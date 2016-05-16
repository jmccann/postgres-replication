default['postgres-replication']['master']['ip'] = ''
default['postgres-replication']['archive_dir'] = "/var/lib/postgresql/#{node['postgresql']['version']}/mnt/server/archivedir"
default['postgres-replication']['vault'] = 'vault_postgresql'

default['postgres-replication']['recovery']['config']['standby_mode'] = 'on'
