rightscale_marker :begin

include_recipe "apache2"

if platform?("redhat", "centos", "scientific", "fedora")
    package "mod_geoip" do
        notifies :run, resources(:execute => "generate-module-list"), :immediately
        action :install
    end
   
    # delete stock config
    file "#{node[:apache][:dir]}/conf.d/geoip.conf" do
        action :delete
        backup false
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

    template "#{node[:apache][:dir]}/mods-available/geoip.load" do
        Chef::Log.info "BB: Template #{node[:apache][:dir]}/mods-available/geoip.load"
        source "geoip.load.erb"
        notifies :restart, resources(:service => "apache2")
        mode 0644
    end
end

apache_module "geoip"

rightscale_marker :end
