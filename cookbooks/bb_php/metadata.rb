maintainer       "Broken Bulb Studios"
maintainer_email "matt@brokenbulbstudios.com"
license          "All rights reserved"
description      "Installs/Configures bb_php"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "rightscale"

recipe "bb_php::default","Configures BB PHP Environment"
recipe "bb_php::install_private_key","Installs private key"
recipe "bb_php::install_public_key","Installs public key"
recipe "bb_php::httpd_graceful","Gracefully restart httpd"
recipe "bb_php::ssh_keyscan","Add ssh host to known_hosts"
recipe "bb_php::symlink_latest","Symlink latest code pull"
recipe "bb_php::symlink_last","Symlink last-to-latest code pull"

attribute "bb_php/ssh_keyscan_host",
  :display_name => "Host to add",
  :description => "Host to scan and add to known_hosts",
  :required => "required",
  :recipes => ["bbphp::ssh_keyscan"]
