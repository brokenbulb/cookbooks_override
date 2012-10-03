#
# Cookbook Name:: bb_php
# Recipe:: install_private_key
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Installs private key for accessing other instances 
rightscale_marker :begin

directory "/root/.ssh" do
  owner "root"
  group "root"
  mode "0600"
  action :create
end

execute "installpublickey" do
  filename = ::File.join(::File.dirname(__FILE__), "..", "files", "default", "id_rsa_cloud")
  command "cat " + filename + " > /root/.ssh/id_rsa_cloud"
  command "chmod 0600 /root/.ssh/id_rsa_cloud"
  action :run
end

rightscale_marker :end
