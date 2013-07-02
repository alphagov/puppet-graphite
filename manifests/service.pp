class graphite::service {
  service { 'carbon-cache':
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
