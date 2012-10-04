#
# Cookbook Name:: bb_php
# Recipe:: httpd_graceful
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Gracefully restarts httpd 



service "httpd" do
  restart_command "service httpd graceful"
  action :restart
end


