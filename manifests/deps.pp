# == Class: graphite::deps
#
# Class to create a Python virtualenv and install all graphite dependencies
# within that sandbox.
#
# With the exception of pycairo which can't be installed by pip. It is
# installed as a system package and symlinked into the virtualenv. This is a
# slightly hacky alternative to `--system-site-packages` which would mess
# with Graphite's other dependencies.
#
class graphite::deps {
  $root_dir = $::graphite::root_dir

  if $::graphite::database_engine == 'mysql' {
    $extra_pip_packages = 'MySQL-python'
    # the Python module for mysql needs the mysql_config binary in order to install 
    package {'libmysqlclient-dev':
        ensure => installed,
        before => Python::Pip[$extra_pip_packages],
    }
  } elsif ( $::graphite::database_engine == 'postgresql' or $::graphite::database_engine == 'postgresql_psycopg2') {
    $extra_pip_packages = 'psycopg2'
  }

  python::virtualenv { $root_dir: } ->
  python::pip { [
    'gunicorn',
    'twisted==11.1.0',
    'django==1.4.10',
    'django-tagging==0.3.1',
    'python-memcached==1.47',
    'pytz',
    'simplejson==2.1.6',
  ]:
    virtualenv => $root_dir,
  }

  if $extra_pip_packages {
    python::pip { $extra_pip_packages:
      require    => Python::Virtualenv[$root_dir],
      virtualenv => $root_dir,
    }
  }

  ensure_packages(['python-cairo'])

  file { "${root_dir}/lib/python2.7/site-packages/cairo":
    ensure  => link,
    target  => '/usr/lib/python2.7/dist-packages/cairo',
    require => [
      Python::Virtualenv[$root_dir],
      Package['python-cairo'],
    ],
  }
}
