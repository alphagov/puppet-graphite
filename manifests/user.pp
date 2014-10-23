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
    home       => '/opt/graphite',
    require    => Group['carbon_cache_group']
  }

}
