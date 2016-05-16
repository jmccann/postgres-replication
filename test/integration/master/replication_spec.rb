# Make sure we see original row
describe command('su - postgres -c "psql -U postgres -c \"SELECT * FROM guestbook WHERE message = \'This is a test.\';\" | grep \'(1 row)\'"') do
  its('exit_status') { should eq 0 }
end

# Insert new row that should replicate to slave
describe command('su - postgres -c "psql -U postgres -c \"INSERT INTO guestbook (visitor_email, date, message) VALUES ( \'jim@gmail.com\', current_date, \'Now we are replicating.\');\""') do
  its('exit_status') { should eq 0 }
end
