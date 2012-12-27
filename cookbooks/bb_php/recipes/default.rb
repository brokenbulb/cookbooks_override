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

yum_package "htop" do
  arch "x86_64"
end

# We're going to use the couchbase version which includes memcached_touch
#execute "peclmemcached" do
#  command "pecl install memcached"
#  creates "/usr/lib64/php/modules/memcached.so"
#  action :run
#end

execute "pearlog" do
  command "pear install Log"
  creates "/usr/share/pear/Log.php"
  action :run
end

execute "installinugamipublickey" do
  filename = ::File.join(::File.dirname(__FILE__), "..", "files", "default", "id_dsa.pub")
  command "cat " + filename + " >> /root/.ssh/authorized_keys"
  action :run
end

execute "copymemcached" do
  filename = ::File.join(::File.dirname(__FILE__), "..", "files", "centos-misc", "memcached.so")
  creates "/usr/lib64/php/modules/memcached.so"
  command "mv " + filename + " /usr/lib64/php/modules/"
  action :run
end

execute "copycouchbase10x" do
  filename = ::File.join(::File.dirname(__FILE__), "..", "files", "centos-misc", "couchbase.1.0.x.so")
  creates "/usr/lib64/php/modules/couchbase.1.0.x.so"
  command "mv " + filename + " /usr/lib64/php/modules/"
  action :run
end

execute "copycouchbase" do
  filename = ::File.join(::File.dirname(__FILE__), "..", "files", "centos-misc", "couchbase.so")
  creates "/usr/lib64/php/modules/couchbase.so"
  command "mv " + filename + " /usr/lib64/php/modules/"
  action :run
end

execute "copyvirtualhost" do
  filename = ::File.join(::File.dirname(__FILE__), "..", "files", "config", "httpd", "bakeshopdrop.conf")
  Chef::Log.info "BB: Copy virtual host " + filename
  command "cp -f " + filename + " /etc/httpd/sites-available/"
  action :run
end

execute "copyvirtualhost" do
  filename = ::File.join(::File.dirname(__FILE__), "..", "files", "config", "httpd", "sodapoppanic.conf")
  Chef::Log.info "BB: Copy virtual host " + filename
  command "cp -f " + filename + " /etc/httpd/sites-available/"
  action :run
end

execute "copyvirtualhost" do
  filename = ::File.join(::File.dirname(__FILE__), "..", "files", "config", "httpd", "superheroes_current.conf")
  Chef::Log.info "BB: Copy virtual host " + filename
  command "cp -f " + filename + " /etc/httpd/sites-available/"
  action :run
end

execute "copyxdebugini" do
  filename = ::File.join(::File.dirname(__FILE__), "..", "files", "config", "php", "xdebug.ini")
  command "cp -f " + filename + " /etc/php.d/xdebug.ini"
end

execute "createphpinimemcached" do
  creates "/etc/php.d/memcached.ini"
  command "echo 'extension=memcached.so' >> /etc/php.d/memcached.ini"
  action :run
end

# Call the ini file z_couchbase.ini to ensure it gets processed last, after json.ini
execute "createphpinicouchbase" do
  creates "/etc/php.d/z_couchbase.ini"
  command "echo 'extension=couchbase.so' >> /etc/php.d/z_couchbase.ini"
  action :run
end

# Hostname Lookups are off, so the default "Allow from localhost" doesn't seem to work
execute "fixstatusconf" do
  command "sed -i 's/<\\/Location>/    Allow from 127.0.0.1\\n<\\/Location>/g' /etc/httpd/conf.d/status.conf"
  action :run
end

execute "pecligbinary" do
  command "pecl install igbinary"
  creates "/usr/lib64/php/modules/igbinary.so"
  action :run
end

execute "createphpiniigbinary" do
  creates "/etc/php.d/igbinary.ini"
  command "echo 'extension=igbinary.so' >> /etc/php.d/igbinary.ini"
  action :run
end

execute "configure_php_ini" do
  command "sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php.ini"
  action :run
end

# Create superheroes log files
directory "/var/log/superheroes" do
  owner "apache"
  group "apache"
  mode "0755"
  recursive true
  action :create
end

%w{general.log sql.log}.each do |f|
  file "/var/log/superheroes/#{f}" do
    owner "apache"
    group "apache"
    mode "0755"
    action :create
  end
end

# Soda Pop Panic
directory "/var/log/soda" do
  owner "apache"
  group "apache"
  mode "0755"
  recursive true
  action :create
end

%w{general.log sql.log}.each do |f|
  file "/var/log/soda/#{f}" do
    owner "apache"
    group "apache"
    mode "0755"
    action :create
  end
end

# Bake Shop Drop
directory "/var/log/bake" do
  owner "apache"
  group "apache"
  mode "0755"
  recursive true
  action :create
end

%w{general.log sql.log}.each do |f|
  file "/var/log/bake/#{f}" do
    owner "apache"
    group "apache"
    mode "0755"
    action :create
  end
end

# install geoip
if platform?("redhat", "centos", "scientific", "fedora")
    package "mod_geoip" do
        action :install
    end
  
    directory "/usr/local/share/GeoIP" do
        Chef::Log.info "Create directory" 
        recursive true
        action :create
    end

    execute "copygeoipdat" do
        Chef::Log.info "BB: Copy data" 
        filename = ::File.join(::File.dirname(__FILE__), "..", "files", "centos-misc", "GeoIP.dat")
        creates "/usr/local/share/GeoIP/GeoIP.dat"
        command "mv " + filename + " /usr/local/share/GeoIP/"
        action :run
    end
    
    # delete stock config
    file "#{node[:apache][:dir]}/conf.d/mod_geoip.conf" do
        action :delete
        backup false
    end
   
    template "#{node[:apache][:dir]}/mods-available/geoip.load" do
        Chef::Log.info "BB: Template #{node[:apache][:dir]}/mods-available/geoip.load"
        source "geoip.load.erb"
        mode 0644
    end
    
    template "#{node[:apache][:dir]}/mods-available/geoip.conf" do
        Chef::Log.info "BB: Template #{node[:apache][:dir]}/mods-available/geoip.conf"
        source "geoip.conf.erb"
        mode 0644
    end
    
    execute "a2enmod geoip" do
      command "/usr/sbin/a2enmod geoip"
    end
end

# Restart httpd
service "httpd" do
  action :restart
end


