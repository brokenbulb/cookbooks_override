#
# Cookbook Name:: bb_php
# Recipe:: default
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Configures BB PHP Environment

arch = (node[:kernel][:machine] == "x86_64") ? "64" : "i386"
type = (node[:platform] == 'ubuntu') ? "deb" : "rpm"

# Find and install local packages, not worrying about dependencies
packages = ::File.join(::File.dirname(__FILE__), "..", "files", "packages", "*#{arch}.#{type}")
Dir.glob(packages).each do |p|
  package p do
    not_if { type == "deb" }
    source p
	options "--skip-broken --nogpgcheck"
    action :install
  end
end
