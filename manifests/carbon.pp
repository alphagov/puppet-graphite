class graphite::carbon {
  package { 'python-twisted':
    ensure => latest
  }

  package { 'carbon':
    ensure   => installed,
    provider => pip,
  }

  file { '/etc/init.d/carbon':
    ensure => present,
    source => 'puppet:///modules/graphite/carbon',
  }

  file { '/opt/graphite/conf/carbon.conf':
    ensure    => present,
    content   => template('graphite/carbon.conf'),
    notify    => Service['carbon'],
    subscribe => Package['carbon'],
  }

  file { '/opt/graphite/conf/storage-schemas.conf':
    ensure    => present,
    source    => 'puppet:///modules/graphite/storage-schemas.conf',
    notify    => Service['carbon'],
    subscribe => Package['carbon'],
  }

  file { '/var/log/carbon':
    ensure => directory,
    owner  => www-data,
    group  => www-data,
  }

  service { 'carbon':
    ensure  => running,
    require => File['/etc/init.d/carbon'],
  }
}
