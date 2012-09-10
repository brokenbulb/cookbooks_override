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

execute "git_clone" do
  RightScale::Repo::Ssh_key.new.create(node[:repo][:default][:git_ssh_key])
  command "NEWDIR=/home/capistrano_repo/releases/`date +%s`; mkdir -p $NEWDIR; cd $NEWDIR; git clone git@github.com:brokenbulb/SuperheroesLive.git $NEWDIR"
  RightScale::Repo::Ssh_key.new.delete
end
