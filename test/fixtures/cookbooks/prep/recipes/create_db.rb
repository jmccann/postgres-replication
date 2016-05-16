execute 'create table' do
  user 'postgres'
  command 'psql -U postgres -c "CREATE TABLE guestbook (visitor_email text, vistor_id serial, date timestamp, message text);"'
  not_if 'psql -U postgres -c "SELECT * FROM guestbook;"'
end

execute 'insert initial record' do
  user 'postgres'
  command "psql -U postgres -c \"INSERT INTO guestbook (visitor_email, date, message) VALUES ( 'jim@gmail.com', current_date, 'This is a test.');\""
  only_if "psql -U postgres -c \"SELECT * FROM guestbook WHERE visitor_email = 'jim@gmail.com';\" | grep '(0 rows)'"
end
