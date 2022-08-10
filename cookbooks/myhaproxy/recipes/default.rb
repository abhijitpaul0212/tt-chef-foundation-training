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

# web_nodes = search('node', 'policy_name:company_web')
web_nodes = search('node', "policy_name:company_web AND policy_group:#{node.policy_group}")

server_array = []

web_nodes.each do |web_node|
  web_server = "#{web_node['cloud']['public_hostname']} #{web_node['cloud']['public_ipv4']}:80 maxconn 32"
  server_array.push(web_server)
end

haproxy_backend 'server_backend' do
  # server [
  #   'ec2-3-83-225-172.compute-1.amazonaws.com 3.83.225.172:80 maxconn 32',
  #   'ec2-100-26-3-47.compute-1.amazonaws.com 100.26.3.47:80 maxconn 32'
  # ]
  server server_array
end

haproxy_service 'haproxy' do
  # action [ :enable, :start ]
  subscribes :reload, 'template[/etc/haproxy/haproxy.cfg]', :delayed
end