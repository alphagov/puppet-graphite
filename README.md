A Puppet module for managing the installation of
[Graphite](http://graphite.wikidot.com/).

[![Build
Status](https://secure.travis-ci.org/gds-operations/puppet-graphite.png)](http://travis-ci.org/gds-operations/puppet-graphite)

# Usage

You will need Python, Python's development headers/libs, pip and virtualenv
installed. If you're not already managing these you can use the `python`
module, which is included as a dependency:

```puppet
class { 'python':
  pip        => true,
  dev        => true,
  virtualenv => true,
}
```

Then for the simplest possible configuration:

```puppet
include graphite
```

## Configuration

If you want to run the web interface on a port other than 80 you can
pass this in like so:

```puppet
class { 'graphite':
  port => 9000,
}
```

## Versioning

If you want to install a specific version of whisper and carbon, you
like so:

```puppet
class { 'graphite':
  port    => 9000,
  version => '0.9.12',
}
```

## Another Graphite module?

Graphite can be painfull to install and many blog posts and gists are
dedicated to that fact. However it appears to have got easier with most
of the components now available in the Python Package repository. All
the other puppet modules I found either lacked support for
Ubuntu/Debian, relied on an undocumented package or did a lot of
wgetting. 

Although I've only tested this module on Ubuntu it should work on other
distros too, maybe with minor tweaks.
