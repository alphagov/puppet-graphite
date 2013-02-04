class graphite(
  $admin_password = $graphite::params::admin_password,
  $port = $graphite::params::port,
) inherits graphite::params {
  class{'graphite::install': } ->
  class{'graphite::config': } ~>
  class{'graphite::service': } ->
  Class['graphite']
}
