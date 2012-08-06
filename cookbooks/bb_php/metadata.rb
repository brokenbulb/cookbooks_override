maintainer       "Broken Bulb Studios"
maintainer_email "matt@brokenbulbstudios.com"
license          "All rights reserved"
description      "Installs/Configures bb_php"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "bb_php::default","Configures BB PHP Environment"
recipe "bb_php::install_private_key","Installs private key"
recipe "bb_php::install_public_key","Installs public key"
