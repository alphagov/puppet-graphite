class graphite::install {

  ensure_packages([
    'python-virtualenv',
    'python-pip',
  ])

  file { '/opt/graphite':
    ensure => directory,
  }

  exec { 'graphite/create virtualenv':
    command => '/usr/bin/virtualenv /opt/graphite',
    creates => '/opt/graphite/bin/pip',
    require => File['/opt/graphite'],
  }

  exec { 'graphite/install whisper':
    command => '/opt/graphite/bin/pip install whisper',
    creates => '/opt/graphite/bin/whisper-create.py',
    require => Exec['graphite/create virtualenv'],
  }

  exec { 'graphite/install carbon':
    command => '/opt/graphite/bin/pip install carbon',
    creates => '/opt/graphite/bin/carbon-cache.py',
    require => Exec['graphite/create virtualenv'],
  }

  exec { 'graphite/install graphite-web':
    command => '/opt/graphite/bin/pip install graphite-web',
    creates => '/opt/graphite/webapp/graphite/manage.py',
    require => Exec['graphite/create virtualenv'],
  }

  exec { 'graphite/install gunicorn':
    command => '/opt/graphite/bin/pip install gunicorn',
    creates => '/opt/graphite/bin/gunicorn',
    require => Exec['graphite/create virtualenv'],
  }

  file { '/var/log/carbon':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
  }

}
