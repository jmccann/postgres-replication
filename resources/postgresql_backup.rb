resource_name :postgresql_backup

property :name, String
property :ip, String, required: true
property :port, [Integer, String], default: 5432
property :directory, String, required: true
property :user, String, required: true
property :verbose, [TrueClass, FalseClass], default: false
property :xlog_method, String
property :password, String, required: true

action :run do
  cmd = ['pg_basebackup']
  cmd << "-h #{new_resource.ip}"
  cmd << "-p #{new_resource.port}"
  cmd << "-D #{new_resource.directory}"
  cmd << "-U #{new_resource.user}"
  cmd << '-v' if new_resource.verbose
  cmd << "-X #{new_resource.xlog_method}" if new_resource.xlog_method

  file 'pgpass' do
    path '/var/lib/postgresql/.pgpass'
    content "#{new_resource.ip}:#{new_resource.port}:*:#{new_resource.user}:#{new_resource.password}\n"
    owner 'postgres'
    group 'postgres'
    mode '0600'
    sensitive true
  end

  execute 'backup' do
    user 'postgres'
    command cmd.join(' ')
  end
end
