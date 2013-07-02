class graphite(
  $admin_password = $graphite::params::admin_password,
  $port = $graphite::params::port,
  $storage_root = $graphite::params::storage_root,
) inherits graphite::params {
  class{'graphite::install': } ->
  class{'graphite::config': } ~>
  class{'graphite::service': } ->
  Class['graphite']
}
