class graphite::install {

  package {[
    'python-ldap',
    'python-cairo',
    'python-django',
    'python-twisted',
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

  exec { 'install-carbon':
    command => 'pip install carbon',
    creates => '/opt/graphite/lib/carbon',
  }

  exec { 'install-graphite-web':
    command => 'pip install graphite-web',
    creates => '/opt/graphite/webapp/graphite',
  }

  package { 'whisper':
    ensure   => installed,
    provider => pip,
  }

  file { '/var/log/carbon':
    ensure => directory,
    owner  => www-data,
    group  => www-data,
  }

}
