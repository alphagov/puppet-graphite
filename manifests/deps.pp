# == Class: graphite::deps
#
# Installs all graphite dependency packages
#
class graphite::deps {

  ensure_packages([
    'python-ldap',
    'python-cairo',
    'python-django',
    'python-twisted',
    'python-django-tagging',
    'python-simplejson',
    'python-memcache',
    'python-pysqlite2',
    'python-support',
    'python-pip',
    'gunicorn',
  ])

}
