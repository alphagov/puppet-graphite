class graphite::service {
  service { 'carbon':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    provider   => upstart,
  }
}
