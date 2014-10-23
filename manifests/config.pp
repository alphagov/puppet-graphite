# == Class: graphite::config
#
# Class to set up all graphite related configuration files and dependencies.
#
class graphite::config {

  $admin_password = $::graphite::admin_password
  $bind_address = $::graphite::bind_address
  $port = $::graphite::port
  $root_dir = $::graphite::root_dir

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
    owner   => $::graphite::user,
    group   => $::graphite::group,
    mode    => '0444',
  }

  file { '/etc/init/carbon-cache.conf':
    ensure  => present,
    content => template('graphite/upstart/carbon-cache.conf'),
    owner   => $::graphite::user,
    group   => $::graphite::group,
    mode    => '0444',
  }

  file { '/etc/init/graphite-web.conf':
    content => template('graphite/upstart/graphite-web.conf'),
    owner   => $::graphite::user,
    group   => $::graphite::group,
    mode    => '0444',
  }

file { "${root_dir}/conf/carbon.conf":
    content => template('graphite/carbon.conf'),
    owner   => $::graphite::user,
    group   => $::graphite::group,
    mode    => '0444',
    require => Package['python-carbon'],
  }

  file { "${root_dir}/conf/aggregation-rules.conf":
    ensure  => $aggregation_rules_ensure,
    content => $::graphite::aggregation_rules_content,
    source  => $::graphite::aggregation_rules_source,
    owner   => $::graphite::user,
    group   => $::graphite::group,
    mode    => '0444',
    require => Package['python-carbon'],
  }



  file { "${root_dir}/conf/storage-aggregation.conf":
    ensure  => present,
    content => $storage_aggregation_content,
    source  => $storage_aggregation_source,
    owner   => $::graphite::user,
    group   => $::graphite::group,
    mode    => '0444',
    require => Package['python-carbon'],
  }

  file { "${root_dir}/conf/storage-schemas.conf":
    ensure  => present,
    content => $storage_schemas_content,
    source  => $storage_schemas_source,
    owner   => $::graphite::user,
    group   => $::graphite::group,
    mode    => '0444',
    require => Package['python-carbon'],
  }

  file { [ '/opt/graphite/storage', '/opt/graphite/storage/whisper' ]:
    ensure => directory,
  }

  # Using Exec instead of File resource, simply because the graphite directory
  # can grow very large, and managing large directories with Puppet can lead
  # to memory starvation.
  # The exec will use xargs and parralise chmod, so even for large directories
  # it should run pretty quickly.
  exec { 'set_graphite_ownership':
    command     => "find /opt/graphite/storage | xargs -n 50 -P 4 chown ${::graphite::user}:${graphite::group}",
    refreshonly => true,
    require     => File['/opt/graphite/storage'],
    subscribe   => [
                      File['/etc/init/graphite-web.conf'],
                      File['/etc/init/carbon-cache.conf'],
                      File['/opt/graphite/storage'],
                  ],
    before      => [ Service['graphite-web'], Service['carbon-cache'] ],
  }

  exec { 'init-db':
    command   => "${root_dir}/bin/python manage.py syncdb --noinput",
    cwd       => "${root_dir}/webapp/graphite",
    creates   => "${root_dir}/storage/graphite.db",
    subscribe => File["${root_dir}/storage"],
    require   => File["${root_dir}/webapp/graphite/initial_data.json"],
  }

  file { "${root_dir}/webapp/graphite/initial_data.json":
    ensure  => present,
    require => File["${root_dir}/storage"],
    content => template('graphite/initial_data.json'),
  }

  file { "${root_dir}/storage/graphite.db":
    owner     => 'www-data',
    mode      => '0664',
    subscribe => Exec['init-db'],
  }

  file { "${root_dir}/storage/log/webapp/":
    ensure => directory,
    owner  => $::graphite::user,
    mode   => '0775',
  }

  file { "${root_dir}/webapp/graphite/local_settings.py":
    ensure  => present,
    source  => 'puppet:///modules/graphite/local_settings.py',
    owner   => $::graphite::user,
    group   => $::graphite::group,
    mode    => '0444',
    require => Package['python-graphite-web'],
  }

}
