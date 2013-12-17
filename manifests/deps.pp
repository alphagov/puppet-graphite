# == Class: graphite::deps
#
# Class to install all graphite dependency packages
#
class graphite::deps {

  # common packages
  ensure_packages([
    'python-ldap',
    'python-twisted',
    'python-django-tagging',
    'python-simplejson',
    'python-pip',
  ])

  # OS-specific packages
  case $::osfamily {
    'RedHat': {
      ensure_packages([
        'python-memcached',
        'python-gunicorn',
        'Django14',
        'python-sqlite2',
        'pycairo',
      ])
    }
    # Ubuntu/other
    default: {
      ensure_packages([
        'python-memcache',
        'gunicorn',
        'python-django',
        'python-pysqlite2',
        'python-cairo',
        'python-support',
      ])
    }
  }

}
