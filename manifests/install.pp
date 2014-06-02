# == Class: graphite::install
#
# Class to install graphite as a package
#
class graphite::install {
  $root_dir = $::graphite::root_dir
  $ver = $::graphite::version

  python::pip { [
    'whisper',
    'carbon',
    'graphite-web'
  ]:
    ensure      => $ver,
    virtualenv  => $root_dir,
    environment => ["PYTHONPATH=${root_dir}/lib:${root_dir}/webapp"],
  }

}
