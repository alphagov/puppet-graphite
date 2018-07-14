# == Class: graphite::params
#
# Class to set default graphite params
#
class graphite::params {
  $admin_password = hiera('admin_pwd')
  $bind_address = '127.0.0.1'
  $port = 8000
  $root_dir = '/opt/graphite'
  $version = '0.9.12'
  $user = 'www-data'
  $group = 'www-data'
  $time_zone = 'UTC'
  $django_secret_key = undef
  $memcache_hosts = []
}
