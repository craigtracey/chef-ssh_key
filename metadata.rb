maintainer       "Craig Tracey"
maintainer_email "craigtracey@gmail.com"
license          "Apache 2.0"
description      "Add and remove ssh keys for existing users/groups of users"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1"

%w{ ubuntu debian redhat centos fedora freebsd}.each do |os|
  supports os
end
