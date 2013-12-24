# == Class: graphite::install
#
# Class to install graphite as a package
#
class graphite::install {
  $root_dir = $::graphite::root_dir
  $ver = $::graphite::version

  package { 'whisper':
    ensure   => $ver,
    provider => pip,
  }

  $carbon_pip_args = [
    "--install-option=\"--prefix=${root_dir}\"",
    "--install-option=\"--install-lib=${root_dir}/lib\"",
  ]
  $carbon_args = join($carbon_pip_args, ' ')

  exec { 'graphite/install carbon':
    command => "/usr/bin/pip install ${carbon_args} carbon==${ver}",
    creates => "${root_dir}/bin/carbon-cache.py",
  }

  $graphite_pip_args = [
    "--install-option=\"--prefix=${root_dir}\"",
    "--install-option=\"--install-lib=${root_dir}/webapp\""
  ]
  $graphite_web_args = join($graphite_pip_args, ' ')

  exec { 'graphite/install graphite-web':
    command => "/usr/bin/pip install ${graphite_web_args} graphite-web==${ver}",
    creates => "${root_dir}/webapp/graphite/manage.py",
  }

  file { '/var/log/carbon':
    ensure => directory,
    owner  => www-data,
    group  => www-data,
  }

}
