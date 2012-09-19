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
    bash 'create_temp_git_ssh_key' do
        log "chmod 700 #{ssh_key_file}"
        log "exec ssh -oStrictHostKeyChecking=no -i #{ssh_key_file} $@ > #{ssh_wrapper}"
        code <<-EOH
            chmod 700 #{ssh_key_file}
            echo 'exec ssh -oStrictHostKeyChecking=no -i #{ssh_key_file} "$@"' > #{ssh_wrapper}
            chmod +x #{ssh_key_file}
        EOH
    end
end

bash 'git_clone' do
    code <<-EOH
        mkdir -p #{dest} && cd #{dest}
        git clone #{reponame} #{dest} 
    EOH
end

# delete SSH key & clear GIT_SSH
if ssh_key_file != nil
    bash 'delete_temp_git_ssh_key' do
        code <<-EOH
            rm -f #{ssh_key_file}
            rm -f #{ssh_wrapper}
        EOH
    end
end
	
log "  BB git clone done!" 

rightscale_marker :end
