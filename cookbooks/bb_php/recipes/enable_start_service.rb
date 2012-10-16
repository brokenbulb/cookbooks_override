#
# Cookbook Name:: bb_php
# Recipe:: enable_start_service
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Starts/enables services 

if node.nil?
  services = []
else
  services = node[:bb_php][:services_to_start].split(/, ?/)
end

services.each do |svc|
  Chef::Log.info "BB: Starting/enabling service #{svc}"
  service svc do
    # enable on boot and start the service
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
  end
end
