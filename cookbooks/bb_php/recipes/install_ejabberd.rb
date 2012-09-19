#
# Cookbook Name:: bb_php
# Recipe:: ejabberd 
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Install ejabberd 
#

rightscale_marker :begin

package "ejabberd" do
    version "2.1.11-1"
    action :install
end

rightscale_marker :end
