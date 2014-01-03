# -*- mode: ruby -*-
# vi: set ft=ruby :

# FIXME: This shouldn't really have to redeclare the dependencies, but I can't
# find any way around it right now
script = <<EOM
DEBIAN_FRONTEND=noninteractive apt-get -qy update

if [ ! -e /etc/puppet/modules/stdlib ]; then
  puppet module install puppetlabs-stdlib --modulepath /etc/puppet/modules
fi
if [ ! -e /etc/puppet/modules/python ]; then
  puppet module install stankevich-python --modulepath /etc/puppet/modules
fi

puppet apply --verbose -e "node default { \
  class { 'python': \
    pip        => true, \
    dev        => true, \
    virtualenv => true, \
  } \
  class { 'graphite': \
    root_dir => '/var/lib/graphite', \
  } \
}"
EOM

Vagrant.configure("2") do |config|
  config.vm.box = 'precise64'
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.hostname = "graphite.internal"

  config.vm.synced_folder ".", "/etc/puppet/modules/graphite"
  config.vm.provision :shell, :inline => script
end
