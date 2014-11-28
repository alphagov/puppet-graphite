# == Class: graphite::user
#
# Class to create and manage the user (and group) used to run Graphite
# and associated services.
#
# This class is only used if $graphite::manage_user is set to true.
#
class graphite::user {

  group { 'carbon_cache_group':
    ensure => present,
    name   => $::graphite::group,
    system => true,
  }

  user { 'carbon_cache_user':
    ensure     => present,
    name       => $::graphite::user,
    gid        => $::graphite::group,
    shell      => '/usr/sbin/nologin',
    system     => true,
    managehome => false,
    home       => $::graphite::root_dir,
    require    => Group['carbon_cache_group']
  }

}
