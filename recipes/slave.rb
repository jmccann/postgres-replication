#
# Cookbook Name:: postgres-replication
# Recipe:: slave
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
