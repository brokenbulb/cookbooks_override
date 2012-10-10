#
# Cookbook Name:: bb_php
# Recipe:: install_package
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Installs packages 

if node.nil?
  packages = []
else
  packages = node[:bb_php][:packages_to_install].split(/, ?/)
end

packages.each do |pkg|
  if pkg.index(":").nil? do
    Chef::Log.info "BB: Installing package #{pkg}"
    package pkg do
      action :install
    end
  else
    pkg, ver = pkg.split(/:/)
    Chef::Log.info "BB: Installing package #{pkg} #{ver}"
    package pkg do
      version ver 
      action :install
    end
  end
end
