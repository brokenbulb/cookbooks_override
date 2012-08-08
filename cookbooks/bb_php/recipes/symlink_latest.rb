#
# Cookbook Name:: bb_php
# Recipe:: symlink_latest 
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Symlink latest release
#

execute "symlinklatest" do
  command "cd /home/capistrano_repo && ln -sfvT /home/capistrano_repo/releases/`ls -t releases/ | head -n 1`/ ./current"
end
