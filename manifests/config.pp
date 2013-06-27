class graphite::config {

  $admin_password = $graphite::admin_password
  $port = $graphite::port

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
  }

  file { '/opt/graphite/conf/storage-schemas.conf':
    ensure    => present,
    source    => 'puppet:///modules/graphite/storage-schemas.conf',
  }

  file { ['/opt/graphite/storage', '/opt/graphite/storage/whisper']:
    owner     => 'www-data',
    mode      => '0775',
  }

  exec { 'init-db':
    command   => 'python manage.py syncdb --noinput',
    cwd       => '/opt/graphite/webapp/graphite',
    creates   => '/opt/graphite/storage/graphite.db',
    subscribe => File['/opt/graphite/storage'],
    require   => File['/opt/graphite/webapp/graphite/initial_data.json'],
  }

  file { '/opt/graphite/webapp/graphite/initial_data.json':
    ensure  => present,
    require => File['/opt/graphite/storage'],
    content => template('graphite/initial_data.json'),
  }

  file { '/opt/graphite/storage/graphite.db':
    owner     => 'www-data',
    mode      => '0664',
    subscribe => Exec['init-db'],
  }

  file { '/opt/graphite/storage/log/webapp/':
    ensure    => 'directory',
    owner     => 'www-data',
    mode      => '0775',
    subscribe => Package['graphite-web'],
  }

  file { '/opt/graphite/webapp/graphite/local_settings.py':
    ensure  => present,
    source  => 'puppet:///modules/graphite/local_settings.py',
    require => File['/opt/graphite/storage']
  }

  apache::mod { 'headers': }
  apache::vhost { 'graphite':
    priority => '10',
    port     => $port,
    template => 'graphite/virtualhost.conf',
    docroot  => '/opt/graphite/webapp',
    logroot  => '/opt/graphite/storage/log/webapp/',
  }

}
