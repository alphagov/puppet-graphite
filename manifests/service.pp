# == Class: graphite::service
#
# Class to start carbon-cache and graphite-web processes
#
class graphite::service {
  if $::osfamily == 'RedHat' {
    $provider = redhat
  } else {
    $provider = upstart
  }

  service { 'carbon-cache':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    provider   => $provider,
  }
  service { 'graphite-web':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    provider   => $provider,
  }
}
