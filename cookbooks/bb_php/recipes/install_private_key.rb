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

cookbook_file "/root/.ssh/id_rsa_cloud" do
  source "id_rsa_cloud"
  owner "root"
  group "root"
  mode "0600"
end

rightscale_marker :end
