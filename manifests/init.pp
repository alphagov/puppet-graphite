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
# [*port*]
#   The port on which to serve the graphite-web user interface.
#
# [*root_dir*]
#   Where to install Graphite.
#
# [*storage_aggregation_content*]
#   Optional: the content of the storage-aggregation.conf file.
#
# [*storage_aggregation_source*]
#   Optional: the source of the storage-aggregation.conf file.

# [*storage_schemas_content*]
#   Optional: the content of the storage-schemas.conf file.
#
# [*storage_schemas_source*]
#   Optional: the source of the storage-schemas.conf file.
#
# [*carbon_conf_content*]
#   Optional: the content of the carbon.conf file.
#
# [*carbon_conf_source*]
#   Optional: the source of the carbon.conf file.


class graphite(
  $admin_password = $graphite::params::admin_password,
  $port = $graphite::params::port,
  $root_dir = $graphite::params::root_dir,
  $storage_aggregation_content = undef,
  $storage_aggregation_source = undef,
  $storage_schemas_content = undef,
  $storage_schemas_source = undef,
  $carbon_source = undef,
  $carbon_content = undef
) inherits graphite::params {
  class{'graphite::deps': } ->
  class{'graphite::install': } ->
  class{'graphite::config': } ~>
  class{'graphite::service': } ->
  Class['graphite']
}
