#
# Cookbook Name:: postgres-replication
# Recipe:: master
#
# Copyright (c) 2016 Jacob McCann
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

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
