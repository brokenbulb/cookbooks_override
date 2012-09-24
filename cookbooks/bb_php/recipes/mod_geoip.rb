rightscale_marker :begin

include_recipe "apache2"

if platform?("redhat", "centos", "scientific", "fedora")
    package "geoip" do
        package_name "geoip"
        action :install
        notifies :run, resources(:execute => "generate-module-list"), :immediately
    end
    
#    file "#{node[:apache][:dir]}/conf.d/geoip.conf" do
#        action :delete
#        backup false
#    end
   
	execute "copygeoipdat" do
		filename = ::File.join(::File.dirname(__FILE__), "..", "files", "centos-misc", "GeoIP.dat")
		creates "/usr/local/share/GeoIP.dat"
		command "mv " + filename + " /usr/local/share/"
		action :run
	end
 
#    template "#{node[:apache][:dir]}/geoip.conf" do
#        source "geoip.conf.erb"
#        notifies :restart, resources(:service => "apache2")
#        mode 0644
#    end
end

apache_module "geoip" do
    conf true
end

rightscale_marker :end
