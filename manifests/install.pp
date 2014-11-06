# == Class: graphite::install
#
# Class to install graphite as a package
#
class graphite::install {
  $root_dir = $::graphite::root_dir
  $carbon = $::graphite::carbon_pkg_name
  $whisper = $::graphite::whisper_pkg_name
  $graphite_web = $::graphite::graphite_web_pkg_name
  $ver = $::graphite::version

  if $::graphite::use_python_pip {
    python::pip { [
      "${whisper}==${ver}",
      "${carbon}==${ver}",
    ]:
      virtualenv  => $root_dir,
      environment => ["PYTHONPATH=${root_dir}/lib:${root_dir}/webapp"],
      install_args => "--install-option=\"--prefix=${root_dir}\" --install-option=\"--install-lib=${root_dir}/lib\""
    }
    python::pip { [
      "${graphite_web}==${ver}"
    ]:
      virtualenv  => $root_dir,
      environment => ["PYTHONPATH=${root_dir}/lib:${root_dir}/webapp"],
      install_args => "--install-option=\"--prefix=${root_dir}\" --install-option=\"--install-lib=${root_dir}/webapp\""
    }
  }
  else {
    package { [$carbon, $graphite_web, $whisper]:
      ensure => $ver,
    }
  }

}
