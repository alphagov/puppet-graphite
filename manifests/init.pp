# == Class: graphite
#
# Class to install and configure the Graphite metric aggregation and
# graphing system.
#
# === Parameters
#
# [*admin_password*]
#   The (hashed) initial admin password.
#
# [*bind_address*]
#   The address on which to serve the graphite-web user interface.
#   Default: 127.0.0.1
#
# [*port*]
#   The port on which to serve the graphite-web user interface.
#   Default: 8000
#
# [*root_dir*]
#   Where to install Graphite.
#   Default: /opt/graphite
#
# [*carbon_aggregator*]
#   Optional: Boolean, whether to run carbon-aggregator. You will need to
#   provide an appropriate `carbon_content` or `carbon_source` config.
#
# [*aggregation_rules_content*]
#   Optional: the content of the aggregation-rules.conf file.
#
# [*aggregation_rules_source*]
#   Optional: the source of the aggregation-rules.conf file.
#
# [*storage_aggregation_content*]
#   Optional: the content of the storage-aggregation.conf file.
#
# [*storage_aggregation_source*]
#   Optional: the source of the storage-aggregation.conf file.
#
# [*storage_schemas_content*]
#   Optional: the content of the storage-schemas.conf file.
#
# [*storage_schemas_source*]
#   Optional: the source of the storage-schemas.conf file.
#
# [*carbon_content*]
#   Optional: the content of the carbon.conf file.
#
# [*carbon_source*]
#   Optional: the source of the carbon.conf file.
#
# [*version*]
#   Graphite package version to install.
#
class graphite(
  $admin_password = $graphite::params::admin_password,
  $bind_address = $graphite::params::bind_address,
  $port = $graphite::params::port,
  $root_dir = $graphite::params::root_dir,
  $carbon_aggregator = false,
  $aggregation_rules_content = undef,
  $aggregation_rules_source = undef,
  $storage_aggregation_content = undef,
  $storage_aggregation_source = undef,
  $storage_schemas_content = undef,
  $storage_schemas_source = undef,
  $carbon_source = undef,
  $carbon_content = undef,
  $version = $graphite::params::version,
  $user = $graphite::params::user,
  $group = $graphite::params::group,
  $manage_user = false,
  $carbon_max_cache_size = 'inf',
  $carbon_max_creates_per_minute = 'inf',
  $carbon_max_updates_per_second = 'inf',
  $use_python_pip = true,
  $whisper_pkg_name = 'whisper',
  $carbon_pkg_name = 'carbon',
  $graphite_web_pkg_name = 'graphite-web',
) inherits graphite::params {
  validate_string(
    $admin_password,
    $version,
    $user,
    $group,
  )
  validate_bool($manage_user)

  if $::graphite::manage_user {
    class{'graphite::user':}
    Class['graphite::user'] -> Class['graphite::config']
  }

  if $use_python_pip {
    class{'graphite::deps':}
    Class['graphite::deps'] -> Class['graphite::install']
  }

  class{'graphite::install': } ->
  class{'graphite::config': } ~>
  class{'graphite::service': } ->
  Class['graphite']
}
