#
# Cookbook Name:: postgres-replication
# Spec:: slave
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

require 'spec_helper'

describe 'postgres-replication::slave' do
  context 'When all attributes are default, on an unspecified platform' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '15.10') do |node, server|
        node.set['postgres-replication']['master']['ip'] = '10.10.10.5'
        inject_databags server
      end
      runner.converge(described_recipe)
    end

    before do
      stub_command('ls /var/lib/postgresql/9.3/main/recovery.conf').and_return(false)
      stub_command('[ -d /var/lib/postgresql/9.3/main ]').and_return(false)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'installs and configures postgresql server' do
      expect(chef_run).to include_recipe 'postgresql::server'
    end

    it 'deletes password attributes' do
      expect(chef_run).to run_ruby_block "delete all attributes in node['postgresql']['password']"
    end

    it 'moves original main' do
      expect(chef_run).to run_execute 'rename original main'
    end

    it 'performs backup from master' do
      expect(chef_run).to run_postgresql_backup('from master').with(ip: '10.10.10.5', directory: '/var/lib/postgresql/9.3/main', user: 'repuser', password: 'e2b@vp{wARhcmL9', xlog_method: 'stream')
    end

    describe 'recovery.conf' do
      it 'creates recovery.conf' do
        expect(chef_run).to create_template '/var/lib/postgresql/9.3/main/recovery.conf'
      end

      it 'sets standby_mode' do
        expect(chef_run).to render_file('/var/lib/postgresql/9.3/main/recovery.conf').with_content "standby_mode = 'on'"
      end

      it 'sets primary_conninfo' do
        expect(chef_run).to render_file('/var/lib/postgresql/9.3/main/recovery.conf').with_content "primary_conninfo = 'host=10.10.10.5 port=5432 user=repuser password=e2b@vp{wARhcmL9'"
      end
    end
  end
end
