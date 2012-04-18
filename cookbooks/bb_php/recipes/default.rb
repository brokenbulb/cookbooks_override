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

execute "copymemcached" do
  filename = ::File.join(::File.dirname(__FILE__), "..", "files", "centos-misc", "memcached.so")
  creates "/usr/lib64/php/modules/memcached.so"
  command "mv " + filename + " /usr/lib64/php/modules/"
  action :run
end

execute "copycouchbase" do
  filename = ::File.join(::File.dirname(__FILE__), "..", "files", "centos-misc", "couchbase.so")
  creates "/usr/lib64/php/modules/couchbase.so"
  command "mv " + filename + " /usr/lib64/php/modules/"
  action :run
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

directory "/var/log/superheroes" do
  owner "apache"
  group "apache"
  mode "0755"
  action :create
end

execute "touchgenerallog" do
  creates "/var/log/superheroes/general.log"
  command "touch /var/log/superheroes/general.log"
  action :run
end

# Restart httpd
service "httpd" do
  supports :restart => true
  action :start
end

