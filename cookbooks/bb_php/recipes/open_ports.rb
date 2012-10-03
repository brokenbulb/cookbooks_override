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

rule_ports = node[:bb_php][:open_ports].split(/, ?/)
ports.each do |port|
    raise "Invalid port specified: #{port}. Valid range 1-65536" unless port > 0 and port <= 65536
end

include_recipe "iptables"
ports.each do |port|
  sys_firewall port do
    ip_addr "255.0.0.0"
  end
end

rightscale_marker :end
