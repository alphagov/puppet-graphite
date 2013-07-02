class graphite::install {

  $root_dir = $::graphite::root_dir

  ensure_packages([
    'python-virtualenv',
    'python-pip',
  ])

  file { $root_dir:
    ensure => directory,
  }

  exec { 'graphite/create virtualenv':
    command => "/usr/bin/virtualenv '${root_dir}'",
    creates => "${root_dir}/bin/pip",
    require => File[$root_dir],
  }

  # Infuriatingly, neither graphite-web nor carbon understands python packaging,
  # so we get to do their job for them here.
  ensure_packages([
    'libffi-dev',
    'libcairo2-dev',
  ])

  $graphite_deps = [
    'Django==1.1.4',
    'django-tagging==0.3.1',
    'cairocffi==0.5',
    'pytz==2013b',
    'pyparsing==1.5.7',
    'twisted==13.1.0',
    'txAMQP==0.6.2',
  ]

  $graphite_deps_str = join($graphite_deps, ' ')

  exec { 'graphite/install graphite deps':
    command => "'${root_dir}/bin/pip' install ${graphite_deps_str}",
    creates => "${root_dir}/bin/django-admin.py",
    require => [
      Exec['graphite/create virtualenv'],
      Package['libffi-dev'],
      Package['libcairo2-dev'],
    ],
  }

  exec { 'graphite/install whisper':
    command => "'${root_dir}/bin/pip' install whisper",
    creates => "${root_dir}/bin/whisper-create.py",
    require => Exec['graphite/create virtualenv'],
  }

  $carbon_pip_args = [
    "--install-option=\"--prefix=${root_dir}\"",
    "--install-option=\"--install-lib=${root_dir}/lib\"",
  ]

  $carbon_pip_args_str = join($carbon_pip_args, ' ')

  exec { 'graphite/install carbon':
    command => "'${root_dir}/bin/pip' install carbon ${carbon_pip_args_str}",
    creates => "${root_dir}/bin/carbon-cache.py",
    require => Exec['graphite/create virtualenv'],
  }


  $graphite_pip_args = [
    "--install-option=\"--prefix=${root_dir}\"",
    "--install-option=\"--install-lib=${root_dir}/webapp\""
  ]

  $graphite_pip_args_str = join($graphite_pip_args, ' ')

  exec { 'graphite/install graphite-web':
    command => "'${root_dir}/bin/pip' install ${graphite_pip_args_str} graphite-web==0.9.10",
    creates => "${root_dir}/webapp/graphite/manage.py",
    require => Exec['graphite/create virtualenv'],
  }

  # Manually patch graphite to support cairocffi, a cairo binding which can be
  # installed using pip. This can be removed when this commit is released:
  #
  #     https://github.com/graphite-project/graphite-web/commit/d1306e705152c583ca501ac1d4a0fc0d70f6fadd
  #
  exec { 'graphite/patch graphite-web':
    command  => "/usr/bin/patch -tN '${root_dir}/webapp/graphite/render/glyph.py' <<EOM
@@ -12,7 +12,12 @@
 See the License for the specific language governing permissions and
 limitations under the License.\"\"\"

-import os, cairo, math, itertools, re
+import os, math, itertools, re
+try:
+    import cairo
+except ImportError:
+    import cairocffi as cairo
+
 import StringIO
 from datetime import datetime, timedelta
 from urllib import unquote_plus
EOM",
    provider => 'shell',
    unless   => "fgrep -q cairocffi '${root_dir}/webapp/graphite/render/glyph.py'",
    require  => Exec['graphite/install graphite-web'],
  }


  exec { 'graphite/install gunicorn':
    command => "'${root_dir}/bin/pip' install gunicorn",
    creates => "${root_dir}/bin/gunicorn",
    require => Exec['graphite/create virtualenv'],
  }

  file { '/var/log/carbon':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
  }

}
