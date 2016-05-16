# Make sure we see original row
describe command('su - postgres -c "psql -U postgres -c \"SELECT * FROM guestbook WHERE message = \'This is a test.\';\" | grep \'(1 row)\'"') do
  its('exit_status') { should eq 0 }
end

# Make sure we see replication row
describe command('su - postgres -c "psql -U postgres -c \"SELECT * FROM guestbook WHERE message = \'Now we are replicating.\';\" | grep \'(0 rows)\'"') do
  its('exit_status') { should eq 1 }
end
