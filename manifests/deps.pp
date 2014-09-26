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
  $root_dir        = $::graphite::root_dir
  $packages        = $::graphite::packages
  $cairo_target    = $::graphite::cairo_target
  $python_version  = $::graphite::python_version

  python::virtualenv { $root_dir: } ->
  python::pip { [
    'gunicorn',
    'twisted==11.1.0',
    'django==1.4.10',
    'django-tagging==0.3.1',
    'python-memcached==1.47',
    'simplejson==2.1.6',
  ]:
    virtualenv => $root_dir,
  }

  ensure_packages($packages)


  file { "${root_dir}/lib/python${python_version}/site-packages/cairo":
    ensure  => link,
    target  => $cairo_target,
    require => [
      Python::Virtualenv[$root_dir],
      Package[$packages],
    ],
  }
}
