rightscale_marker :begin

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

rightscale_marker :end
