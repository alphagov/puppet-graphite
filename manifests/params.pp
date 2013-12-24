# == Class: graphite::params
#
# Class to set default graphite params
#
class graphite::params {
  $admin_password = 'sha1$1b11b$edeb0a67a9622f1f2cfeabf9188a711f5ac7d236'
  $port = 8000
  $root_dir = '/opt/graphite'
  $version = '0.9.12'
}
