class graphite(
  $admin_password = $graphite::params::admin_password,
  $port = $graphite::params::port,
  $root_dir = $graphite::params::root_dir,
) inherits graphite::params {
  class{'graphite::deps': } ->
  class{'graphite::install': } ->
  class{'graphite::config': } ~>
  class{'graphite::service': } ->
  Class['graphite']
}
