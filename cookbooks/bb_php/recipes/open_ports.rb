#
# Cookbook Name:: bb_php
# Recipe:: open_ports 
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Open iptables ports 

rightscale_marker :begin

include_recipe "iptables"
include_recipe "sys_firewall"

ports = node[:bb_php][:open_ports].split(/, ?/)
ports.each do |port|
    raise "Invalid port specified: #{port}. Valid range 1-65536" unless port > 0 and port <= 65536
    sys_firewall port do
      Chef::Log.info "BB: Opening port #{port}"
      ip_addr "255.0.0.0"
    end
end

rightscale_marker :end
