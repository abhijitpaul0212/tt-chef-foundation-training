#
# Cookbook:: myhaproxy
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.
haproxy_install 'package'

haproxy_frontend 'http-in' do
  bind '*:80'
  default_backend 'server_backend'
end

web_nodes = search('node', 'policy_name:company_web')

server_array = []

web_nodes.each do |one_node|
  one_server = "#{one_node['cloud']['public_hostname']} #{one_node['cloud']['public_ipv4']}:80 maxconn 32"
  server_array.push(one_server)
end

haproxy_backend 'server_backend' do
  # server [
  #   'ec2-3-83-225-172.compute-1.amazonaws.com 3.83.225.172:80 maxconn 32',
  #   'ec2-100-26-3-47.compute-1.amazonaws.com 100.26.3.47:80 maxconn 32'
  # ]
  server server_array
end

haproxy_service 'haproxy' do
  action [ :enable, :start ]
end