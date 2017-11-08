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
# [*carbon_max_cache_size*]
#   Optional: Set Carbon MAX_CACHE_SIZE
#
# [*carbon_max_creates_per_minute*]
#   Optional: Set Carbon MAX_CREATES
#
# [*carbon_max_updates_per_second*]
#   Optional: Set Carbon MAX_UPDATES_PER_MIN
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
# [*user*]
#   Optional: User account used for Graphite services
#
# [*group*]
#   Optional: Group account used for Graphite services
#
# [*manage_user*]
#   Optional: Manage the user and group account with Puppet
#
# [*use_python_pip*]
#   Optional: Use Python pip to install Graphite services. If set to
#   false, then 'Package' resource type is used.
#
# [*whisper_pkg_name*]
#   Optional: Whisper package name
#
# [*carbon_pkg_name*]
#   Optional: Carbon package name
#
# [*graphite_web_pkg_name*]
#   Optional: Grpahite-Web package name
#
# [*time_zone*]
#   Optional: Graphite-web TIME_ZONE setting
#
# [*django_secret_key*]
#   Optional: If not provided the option will not be written to the config file
#
# [*memcache_hosts*]
#   Optional: Array of memcached servers to use. Each should be ip:port
#
class graphite(
  $admin_password = $graphite::params::admin_password,
  $bind_address = $graphite::params::bind_address,
  $port = $graphite::params::port,
  $root_dir = $graphite::params::root_dir,
  $carbon_aggregator = false,
  $carbon_max_cache_size = 'inf',
  $carbon_max_creates_per_minute = 'inf',
  $carbon_max_updates_per_second = 'inf',
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
  $use_python_pip = true,
  $whisper_pkg_name = 'whisper',
  $carbon_pkg_name = 'carbon',
  $graphite_web_pkg_name = 'graphite-web',
  $time_zone = $graphite::params::time_zone,
  $django_secret_key = $graphite::params::django_secret_key,
  $memcache_hosts = $graphite::params::memcache_hosts,
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

  class{'graphite::install': }
  ~> class{'graphite::config': }
  ~> class{'graphite::service': }
  -> Class['graphite']
}
