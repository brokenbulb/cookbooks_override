#
# Cookbook Name:: bb_php
# Recipe:: symlink_last 
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Symlink last release
#

execute "symlinklast" do
  command "cd /home/capistrano_repo && ln -sfvT /home/capistrano_repo/releases/`ls -t releases/ | head -n 2 | tail -n 1`/ ./current"
end
