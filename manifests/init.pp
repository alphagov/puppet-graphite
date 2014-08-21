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
# [*user*]
#   User the graphite-web user interface runs as.
#   Default: www-data for Debian-based, root for RedHat-based systems.
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
class graphite(
  $admin_password = $graphite::params::admin_password,
  $bind_address = $graphite::params::bind_address,
  $port = $graphite::params::port,
  $root_dir = $graphite::params::root_dir,
  $user = $graphite::params::user,
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
) inherits graphite::params {
  class{'graphite::deps': } ->
  class{'graphite::install': } ->
  class{'graphite::config': } ~>
  class{'graphite::service': } ->
  Class['graphite']
}
