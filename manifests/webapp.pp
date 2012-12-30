class graphite::webapp (
    $admin_password = 'sha1$1b11b$edeb0a67a9622f1f2cfeabf9188a711f5ac7d236',
  ){

  file { ['/opt/graphite/storage', '/opt/graphite/storage/whisper']:
    owner     => 'www-data',
    subscribe => Exec['install-graphite-web'],
    mode      => '0775',
  }

  exec { 'init-db':
    command   => 'python manage.py syncdb --noinput',
    cwd       => '/opt/graphite/webapp/graphite',
    creates   => '/opt/graphite/storage/graphite.db',
    subscribe => File['/opt/graphite/storage'],
    require   => [
      File['/opt/graphite/webapp/graphite/initial_data.json'],
      Package['python-django-tagging']
    ]
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
    notify    => Service['httpd'],
  }

  file { '/opt/graphite/storage/log/webapp/':
    ensure    => 'directory',
    owner     => 'www-data',
    mode      => '0775',
    subscribe => Exec['install-graphite-web'],
    notify    => Service['httpd'],
  }

  file { '/opt/graphite/webapp/graphite/local_settings.py':
    ensure  => present,
    source  => 'puppet:///modules/graphite/local_settings.py',
    require => File['/opt/graphite/storage']
  }

  class {'apache':  }

  apache::vhost { 'graphite':
    priority => '10',
    port     => '80',
    template => 'graphite/virtualhost.conf',
    docroot  => '/opt/graphite/webapp',
    logroot  => '/opt/graphite/storage/log/webapp/',
  }

  package {[
      'python-ldap',
      'python-cairo',
      'python-django',
      'python-django-tagging',
      'python-simplejson',
      'libapache2-mod-python',
      'python-memcache',
      'python-pysqlite2',
      'python-support',
      'python-pip',
    ]:
      ensure => latest;
  }

  exec { 'install-graphite-web':
    command => 'pip install graphite-web',
    creates => '/opt/graphite/webapp/graphite';
  }

  package { 'whisper':
    ensure   => installed,
    provider => pip,
  }

}
