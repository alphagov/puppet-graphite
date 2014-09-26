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

Tested on Ubuntu and CentOS 7, though other RHEL variants including < 7.x 
and Fedora should work (bug reports welcome).

# Running Tests

## Spec tests (with rspec)

```
    $ bundle exec rake test
```

## Acceptance tests (with beaker)

```
# List the available test nodes:
$ bundle exec rake beaker_nodes
centos-64-x64
ubuntu-1204-x64

# Run tests against one node
$ BEAKER_set=centos-64-x64 bundle exec rake beaker

# Run tests when Virtualbox is not your default Vagrant provider
$ VAGRANT_DEFAULT_PROVIDER=virtualbox BEAKER_set=ubuntu-1204-x64 bundle exec rake beaker

# Run the tests and do not kill the nodes after the run (to allow debugging)
$ BEAKER_destory=no BEAKER_set=centos-64-x64 bundle exec rake beaker
```
