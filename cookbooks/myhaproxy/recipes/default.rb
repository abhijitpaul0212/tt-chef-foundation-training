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

haproxy_backend 'server_backend' do
  server [
    'ec2-3-83-225-172.compute-1.amazonaws.com 3.83.225.172:80 maxconn 32',
    'ec2-100-26-3-47.compute-1.amazonaws.com 100.26.3.47:80 maxconn 32'
  ]
end

haproxy_service 'haproxy' do
  action [ :enable, :start ]
end