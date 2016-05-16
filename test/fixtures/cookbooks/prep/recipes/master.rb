execute 'ip addr add 192.168.33.10/24 dev enp0s8' do
  not_if 'ip address show dev enp0s8 | grep 192.168.33.10'
end

execute 'ip link set enp0s8 up' do
  not_if 'ip address show dev enp0s8 | grep UP'
end
