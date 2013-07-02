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

  # Manually patch graphite to support cairocffi, a cairo binding which can be
  # installed using pip. This can be removed when this commit is released:
  #
  #     https://github.com/graphite-project/graphite-web/commit/d1306e705152c583ca501ac1d4a0fc0d70f6fadd
  #
  exec { 'graphite/patch graphite-web':
    command => '/usr/bin/patch -tN /opt/graphite/webapp/graphite/render/glyph.py <<EOM
@@ -12,7 +12,12 @@
 See the License for the specific language governing permissions and
 limitations under the License."""

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
EOM',
    unless  => 'fgrep -q cairocffi /opt/graphite/webapp/graphite/render/glyph.py',
    require => Exec['graphite/install graphite-web'],
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
