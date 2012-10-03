#
# Cookbook Name:: bb_php
# Recipe:: httpd_graceful
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Gracefully restarts httpd 

rightscale_marker :begin

service "httpd" do
  restart_command "service httpd graceful"
  action :restart
end

rightscale_marker :end
