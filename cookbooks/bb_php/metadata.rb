maintainer       "Broken Bulb Studios"
maintainer_email "matt@brokenbulbstudios.com"
license          "All rights reserved"
description      "Installs/Configures BB environment"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.3"

depends "repo"
depends "apache2"
depends "iptables"
depends "sys_firewall"

recipe "bb_php::default","Configures BB PHP Environment"
recipe "bb_php::install_private_key","Installs private key"
recipe "bb_php::install_public_key","Installs public key"
recipe "bb_php::httpd_graceful","Gracefully restart httpd"
recipe "bb_php::ssh_keyscan","Add ssh host to known_hosts"
recipe "bb_php::symlink_latest","Symlink latest code pull"
recipe "bb_php::symlink_last","Symlink last-to-latest code pull"
recipe "bb_php::git_clone","Just clone repository to a fresh directory"
recipe "bb_php::install_ejabberd","Install ejabberd"
recipe "bb_php::mod_geoip","Install/enable Apache2 module GeoIP"
recipe "bb_php::install_vhost","Install virtual host to sites-available"
recipe "bb_php::open_ports","Open ports with iptables"

attribute "bb_php/open_ports",
  :display_name => "Ports to open",
  :description => "Comma separated list of ports to open",
  :required => "required",
  :recipes => ["open_ports"]

attribute "bb_php/ssh_keyscan_host",
  :display_name => "Host to add",
  :description => "Host to scan and add to known_hosts",
  :required => "required",
  :recipes => ["ssh_keyscan"]

attribute "bb_php/vhost_template",
  :display_name => "Host template",
  :description => "Host template to add (ie: superherores.conf)",
  :required => "required",
  :recipes => ["vhost_template"]
