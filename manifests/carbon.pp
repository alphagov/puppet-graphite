class graphite::carbon {
  package { 'python-twisted':
    ensure => latest
  }

  exec { 'install-carbon':
    command  => 'pip install carbon',
    creates => '/opt/graphite/lib/carbon';
  }

  file { '/etc/init.d/carbon':
    ensure => link,
    target => '/lib/init/upstart-job',
  }

  file { '/etc/init/carbon.conf':
    ensure => present,
    source => 'puppet:///modules/graphite/carbon.conf',
    mode   => '0555',
  }

  file { '/opt/graphite/conf/carbon.conf':
    ensure    => present,
    content   => template('graphite/carbon.conf'),
    notify    => Service['carbon'],
    subscribe => Exec['install-carbon'],
  }

  file { '/opt/graphite/conf/storage-schemas.conf':
    ensure    => present,
    source    => 'puppet:///modules/graphite/storage-schemas.conf',
    notify    => Service['carbon'],
    subscribe => Exec['install-carbon'],
  }

  file { '/var/log/carbon':
    ensure => directory,
    owner  => www-data,
    group  => www-data,
  }

  service { 'carbon':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    provider   => upstart,
    require    => [
      File['/etc/init/carbon.conf'],
      File['/etc/init.d/carbon'],
    ],
  }
}
