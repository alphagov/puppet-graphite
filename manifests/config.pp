# == Class: graphite::config
#
# Class to set up all graphite related configuration files and dependencies.
#
class graphite::config {

  $admin_password = $::graphite::admin_password
  $bind_address = $::graphite::bind_address
  $port = $::graphite::port
  $root_dir = $::graphite::root_dir
  $user = $::graphite::user
  $group = $::graphite::group
  $carbon_max_cache_size = $::graphite::carbon_max_cache_size
  $carbon_max_updates_per_second = $::graphite::carbon_max_updates_per_second
  $carbon_max_creates_per_minute = $::graphite::carbon_max_creates_per_minute
  $timezone = $::graphite::timezone
  $memcache_hosts = $::graphite::memcache_hosts
  $database_engine = $::graphite::database_engine
  $database_name = $::graphite::database_name
  $database_user = $::graphite::database_user
  $database_password = $::graphite::database_password
  $database_host = $::graphite::database_host
  $database_port = $::graphite::database_port
  $django_secret_key = $::graphite::django_secret_key

  if ($::graphite::aggregation_rules_source == undef and
      $::graphite::aggregation_rules_content == undef) {
    $aggregation_rules_ensure = absent
  } else {
    $aggregation_rules_ensure = present
  }

  if ($::graphite::storage_aggregation_source == undef and
      $::graphite::storage_aggregation_content == undef) {
    $storage_aggregation_source = 'puppet:///modules/graphite/storage-aggregation.conf'
    $storage_aggregation_content = undef
  } else {
    $storage_aggregation_source = $::graphite::storage_aggregation_source
    $storage_aggregation_content = $::graphite::storage_aggregation_content
  }

  if ($::graphite::storage_schemas_source == undef and
      $::graphite::storage_schemas_content == undef) {
    $storage_schemas_source = 'puppet:///modules/graphite/storage-schemas.conf'
    $storage_schemas_content = undef
  } else {
    $storage_schemas_source = $::graphite::storage_schemas_source
    $storage_schemas_content = $::graphite::storage_schemas_content
  }

  if ($::graphite::carbon_source == undef and
      $::graphite::carbon_content == undef) {
    $carbon_content = template('graphite/carbon.conf')
    $carbon_source = undef
  } else {
    $carbon_source = $::graphite::carbon_source
    $carbon_content = $::graphite::carbon_content
  }

  if $::graphite::use_python_pip == true {
    $initdb_cmd = "${root_dir}/bin/python manage.py syncdb --noinput"
    $gunicorn_bin = "${root_dir}/bin/gunicorn_django"
  } else {
    $initdb_cmd = '/usr/bin/python manage.py syncdb --noinput'
    $gunicorn_bin = 'gunicorn_django'
  }

  file {
  [
    '/etc/init.d/carbon-aggregator',
    '/etc/init.d/carbon-cache',
    '/etc/init.d/graphite-web'
  ]:
    ensure => link,
    target => '/lib/init/upstart-job',
  }

  file { '/etc/init/carbon-aggregator.conf':
    ensure  => present,
    content => template('graphite/upstart/carbon-aggregator.conf'),
    mode    => '0444',
  }

  file { '/etc/init/carbon-cache.conf':
    ensure  => present,
    content => template('graphite/upstart/carbon-cache.conf'),
    mode    => '0444',
  }

  file { '/etc/init/graphite-web.conf':
    ensure  => present,
    content => template('graphite/upstart/graphite-web.conf'),
    mode    => '0444',
  }

  file { "${root_dir}/conf/carbon.conf":
    ensure  => present,
    content => $carbon_content,
    source  => $carbon_source,
    group   => $::graphite::group,
    mode    => '0444',
  }

  file { "${root_dir}/conf/aggregation-rules.conf":
    ensure  => $aggregation_rules_ensure,
    content => $::graphite::aggregation_rules_content,
    source  => $::graphite::aggregation_rules_source,
    group   => $::graphite::group,
    mode    => '0444',
  }

  file { "${root_dir}/conf/storage-aggregation.conf":
    ensure  => present,
    content => $storage_aggregation_content,
    source  => $storage_aggregation_source,
    group   => $::graphite::group,
    mode    => '0444',
  }

  file { "${root_dir}/conf/storage-schemas.conf":
    ensure  => present,
    content => $storage_schemas_content,
    source  => $storage_schemas_source,
    group   => $::graphite::group,
    mode    => '0444',
  }

  file { [
            "${root_dir}/storage",
            "${root_dir}/storage/whisper",
            "${root_dir}/webapp/graphite",
        ]:
    ensure => directory,
    owner  => $::graphite::user,
    group  => $::graphite::group,
  }

  exec { 'set_graphite_ownership':
    path        => '/bin:/usr/bin:/usr/local/bin',
    command     => "find ${root_dir}/storage ${root_dir}/webapp -print0 | \
                      xargs -0 -n 50 -P 4 \
                      chown ${::graphite::user}:${graphite::group}",
    refreshonly => true,
    require     => File["${root_dir}/storage"],
    subscribe   => [
                      File['/etc/init/graphite-web.conf'],
                      File['/etc/init/carbon-cache.conf'],
                      File["${root_dir}/storage"],
                      File["${root_dir}/webapp/graphite"],
                  ],
    before      => [
                      Service['graphite-web'],
                      Service['carbon-cache'],
                  ],
  }

  exec { 'init-db':
    command     => $initdb_cmd,
    cwd         => "${root_dir}/webapp/graphite",
    refreshonly => true,
    subscribe   => File["${root_dir}/storage"],
    require     => File["${root_dir}/webapp/graphite/initial_data.json"],
  }

  file { "${root_dir}/webapp/graphite/initial_data.json":
    ensure  => present,
    owner   => $::graphite::user,
    group   => $::graphite::group,
    require => File["${root_dir}/storage"],
    content => template('graphite/initial_data.json'),
  }

  file { "${root_dir}/storage/graphite.db":
    owner     => $::graphite::user,
    group     => $::graphite::group,
    mode      => '0664',
    subscribe => Exec['init-db'],
  }

  file { "${root_dir}/storage/log/webapp/":
    ensure => 'directory',
    owner  => $::graphite::user,
    group  => $::graphite::group,
    mode   => '0775',
  }

  file { "${root_dir}/webapp/graphite/local_settings.py":
    ensure  => present,
    content => template('graphite/local_settings.py.erb'),
    owner   => $::graphite::user,
    group   => $::graphite::group,
    mode    => '0444',
    require => [
                  File["${root_dir}/storage"],
                  Exec['set_graphite_ownership']
              ],
    notify  => Exec['init-db'],
  }

}
