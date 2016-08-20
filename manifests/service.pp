# == Class: graphite::service
#
# Class to start carbon-cache and graphite-web processes
#
# == Parameters
#
# [*provider*]
#   The service provider to use
#
class graphite::service (
  $provider = 'upstart'
) {
  $aggregator_ensure = $::graphite::carbon_aggregator ? {
    true    => running,
    default => stopped,
  }

  service { 'carbon-aggregator':
    ensure     => $aggregator_ensure,
    hasstatus  => true,
    hasrestart => false,
    provider   => $provider,
  } ->
  service { 'carbon-cache':
    ensure     => running,
    hasstatus  => true,
    hasrestart => false,
    provider   => $provider,
  }

  service { 'graphite-web':
    ensure     => running,
    hasstatus  => true,
    hasrestart => false,
    provider   => $provider,
  }
}
