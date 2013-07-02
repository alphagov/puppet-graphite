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

  # Infuriatingly, graphite-web doesn't understand python packaging, so we get
  # to do its job for it here.
  ensure_packages([
    'libffi-dev',
    'libcairo2-dev',
  ])

  $graphite_pkgs = [
    'graphite-web==0.9.10',
    'Django==1.1.4',
    'django-tagging==0.3.1',
    'cairocffi==0.5',
    'pytz==2013b',
    'pyparsing==1.5.7'
  ]

  $graphite_pkgs_str = join($graphite_pkgs, ' ')

  exec { 'graphite/install graphite-web':
    command => "/opt/graphite/bin/pip install ${graphite_pkgs_str}",
    creates => '/opt/graphite/webapp/graphite/manage.py',
    require => [
      Exec['graphite/create virtualenv'],
      Package['libffi-dev'],
      Package['libcairo2-dev'],
    ],
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
