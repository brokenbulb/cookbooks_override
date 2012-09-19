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
	file = File.new(ssh_key_file, "w")
	file.write(ssh_key)
	file.close
	
	file ssh_wrapper do
		mode "0711"
		owner "root"
		group "root"
		content "exec ssh -oStrictHostKeyChecking=no -i #{ssh_key_file} \"$@\""
		action :create_if_missing
	end
	
	file ssh_key_file do
		mode "0700"
		owner "root"
		group "root"
		content ssh_key
		action :create_if_missing
	end

	directory dest do
		owner "apache"
		group "apache"
		mode "0700"
		action :create
	end
end

bash 'git_clone' do
    code <<-EOH
        git clone #{reponame} #{dest} 
    EOH
end

# delete SSH key & clear GIT_SSH
if ssh_key_file != nil
    bash 'delete_temp_git_ssh_key' do
		%w{ssh_key_file ssh_wrapper}.each do |f|
			file dir do	
				action :delete
			end
		end
    end
end
	
log "  BB git clone done!" 

rightscale_marker :end
