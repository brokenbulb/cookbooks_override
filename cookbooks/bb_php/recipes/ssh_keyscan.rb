#
# Cookbook Name:: bb_php
# Recipe:: ssh_keyscan 
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Add ssh host to known_hosts 

rightscale_marker :begin

execute "SSH Keyscan" do
	command "ssh-keyscan -t rsa,dsa " + node[:bb_php][:ssh_keyscan_host] + " 2>&1 | sort -u - ~/.ssh/known_hosts > ~/.ssh/tmp_hosts && cat ~/.ssh/tmp_hosts > ~/.ssh/known_hosts"
end

rightscale_marker :end
