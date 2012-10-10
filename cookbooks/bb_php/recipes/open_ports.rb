#
# Cookbook Name:: bb_php
# Recipe:: open_ports 
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Open iptables ports 

if node.nil?
    ports = []
else
    ports = node[:bb_php][:ports_to_open].split(/, ?/).collect{|i| i.to_i}
end

ports.each do |port|
    raise "Invalid port specified: #{port}. Valid range 1-65536" unless port > 0 and port <= 65536
    include_recipe "sys_firewall"
    sys_firewall port do
      Chef::Log.info "BB: Opening port #{port}"
      ip_addr "255.0.0.0"
    end
end
