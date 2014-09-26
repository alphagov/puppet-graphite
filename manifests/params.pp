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
      $user           = 'www-data'
      $sysconfig      = '/etc/default'
      $packages       = ['python-cairo']
      $python_version = '2.7'
      $cairo_target   = "/usr/lib/python${python_version}/dist-packages/cairo"
      $init_style     = 'upstart'
    }
    'RedHat': {
      $user         = 'root'
      $sysconfig    = '/etc/sysconfig'
      $packages     = ['pycairo']
      # RedHat uses different library directories on x86_64 arches
      if ($::architecture == 'x86_64') {
        $libdir = '/usr/lib64'
      } else {
        $libdir = '/usr/lib'
      }
      # Version of RedHat < 7 have Python 2.6 as the default
      if (
          (($::operatingsystem == 'RedHat') or ($::operatingsystem == 'CentOS'))
            and ($::operatingsystemmajrelease < '7')
        )
      {
        $python_version = 2.6
      } else {
        $python_version = 2.7
      }
      $cairo_target = "${libdir}/python${python_version}/site-packages/cairo"
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
