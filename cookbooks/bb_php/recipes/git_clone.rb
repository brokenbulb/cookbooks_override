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

execute "git_clone" do
  keyfile = nil
  ssh_key = node[:repo][:default][:git_ssh_key]
  ssh_wrapper = ssh_key + ".sh"
  reponame = node[:repo][:default][:repository]
  
  if "#{ssh_key}" != ""
    keyfile = "/tmp/gitkey"
    bash 'create_temp_git_ssh_key' do
      code <<-EOH
        echo -n '#{ssh_key}' > #{keyfile}
        chmod 700 #{keyfile}
        echo 'exec ssh -oStrictHostKeyChecking=no -i #{keyfile} "$@"' > #{ssh_wrapper}
        chmod +x #{keyfile}.sh
      EOH
    end
  end

  bash 'git_clone' do
    NEWDIR=/home/capistrano_repo/releases/`date +%s`
    mkdir -p $NEWDIR
    cd $NEWDIR
    git clone #{reponame} $NEWDIR
  end

  # delete SSH key & clear GIT_SSH
  if keyfile != nil
     bash 'delete_temp_git_ssh_key' do
       code <<-EOH
         rm -f #{keyfile}
         rm -f #{ssh_wrapper}
       EOH
     end
  end

  action :run
end
