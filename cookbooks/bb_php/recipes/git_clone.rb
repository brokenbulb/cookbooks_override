#
# Cookbook Name:: bb_php
# Recipe:: git_clone 
#
# Copyright 2012, Broken Bulb Studios
#
# All rights reserved - Do Not Redistribute
#
# Clone git repo 
#

rightscale_marker :begin

ssh_key_file = nil
ssh_key = node[:repo][:default][:git_ssh_key]
reponame = node[:repo][:default][:repository]
dest = "/home/capistrano_repo/releases/" + ::Time.now.strftime("%Y%m%d%H%M") 
log "  Running BB git clone on #{reponame} to #{dest}"

if "#{ssh_key}" != ""
	RightScale::Repo::Ssh_key.new.create(ssh_key)
end

directory dest do
	owner "apache"
	group "root"
	mode "0755"
	action :create
end

execute 'git_clone' do
	command "git clone #{reponame} #{dest}"
	action :run
end

ruby_block 'cleanup' do
	block do
		RightScale::Repo::Ssh_key.new.delete
	end
end

rightscale_marker :end
