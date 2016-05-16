#
# Cookbook Name:: postgres-replication
# Spec:: master
#
# Copyright (c) 2016 Jacob McCann, All Rights Reserved.

require 'spec_helper'

describe 'postgres-replication::master' do
  context 'When all attributes are default, on an unspecified platform' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '15.10') do |_node, server|
        inject_databags server
      end
      runner.converge(described_recipe)
    end

    before do
      stub_command('ls /var/lib/postgresql/9.3/main/recovery.conf').and_return(false)
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

    it 'creates user for replication' do
      expect(chef_run).to create_postgresql_user('repuser').with(replication: true, connection_limit: 5, password: 'e2b@vp{wARhcmL9')
    end

    it 'creates archive directory' do
      expect(chef_run).to create_directory '/var/lib/postgresql/9.3/mnt/server/archivedir'
    end
  end
end
