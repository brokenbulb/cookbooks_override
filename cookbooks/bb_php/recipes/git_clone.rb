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
curtime = ::Time.now.to_i
dest = "/home/capistrano_repo/releases/#{curtime}"
ssh_key_file = "/tmp/gitkey"
ssh_wrapper = "/tmp/git-ssh-wrapper.sh"

log "  Running BB git clone on #{reponame} to #{dest}"

if "#{ssh_key}" != ""
	RightScale::Repo::Ssh_key.new.create(ssh_key)
end

directory dest do
	owner "apache"
	group "apache"
	mode "0700"
	action :create
end

bash 'git_clone' do
    code <<-EOH
        git clone #{reponame} #{dest} 
    EOH
end

#RightScale::Repo::Ssh_key.new.delete(ssh_key)

log "  BB git clone done!" 

rightscale_marker :end
