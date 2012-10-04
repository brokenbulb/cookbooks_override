#
# Cookbook Name:: bb_php
# Recipe:: install_public_key
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Installs public key for accessing by other instances 


directory "/root/.ssh" do
  owner "root"
  group "root"
  mode "0600"
  action :create
end

execute "installpublickey" do
  filename = ::File.join(::File.dirname(__FILE__), "..", "files", "default", "id_rsa_cloud.pub")
  command "cat " + filename + " >> /root/.ssh/authorized_keys"
  action :run
end


