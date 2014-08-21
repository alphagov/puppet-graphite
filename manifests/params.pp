# == Class: graphite::params
#
# Class to set default graphite params
#
class graphite::params {
  $admin_password = 'sha1$1b11b$edeb0a67a9622f1f2cfeabf9188a711f5ac7d236'
  $bind_address   = '127.0.0.1'
  $port           = 8000
  $root_dir       = '/opt/graphite'
  $version        = '0.9.12'

  case $::osfamily {
    'Debian': {
      $user         = 'www-data'
      $sysconfig    = '/etc/default'
      $packages     = ['python-cairo']
      $cairo_target = '/usr/lib/python2.7/dist-packages/cairo'
      $init_style   = 'upstart'
    }
    'RedHat': {
      $user         = 'root'
      $sysconfig    = '/etc/sysconfig'
      $packages     = ['pycairo']
      $cairo_target = '/usr/lib64/python2.7/site-packages/cairo'

      if ($::operatingsystem != 'Fedora'
          and versioncmp($::operatingsystemrelease, '7') >= 0)
        or ($::operatingsystem == 'Fedora'
          and versioncmp($::operatingsystemrelease, '15') >= 0) {
          $init_style = 'systemd'
      }
      else {
        $init_style = 'init'
      }
    }
    default: {
      fail("${module_name} not supported on an ${::osfamily} based system.")
    }
  }

}
