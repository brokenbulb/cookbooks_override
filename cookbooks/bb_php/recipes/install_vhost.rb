#
# Cookbook Name:: bb_php
# Recipe:: install_vhost
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Install apache vhost to sites-available
#
rightscale_marker :start

template "/etc/httpd/sites-available/" + node[:bb_php][:vhost_template] do
	source node[:bb_php][:vhost_template] + ".erb"
	notifies :restart, resources(:service => "apache2")
	mode 0644
end

rightscale_marker :end
