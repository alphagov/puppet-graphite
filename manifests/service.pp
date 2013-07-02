class graphite::service {
  service { 'carbon':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    provider   => upstart,
  }
  service { 'graphite-web':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    provider   => upstart,
  }
}
