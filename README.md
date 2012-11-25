A Puppet module for managing the installation of
[Graphite](http://graphite.wikidot.com/).

[![Build
Status](https://secure.travis-ci.org/garethr/garethr-graphite.png)](http://travis-ci.org/garethr/garethr-graphite)

# Usage

Nice and simple, mainly because it's not yet very configurable.

    include graphite

## Configuration

Non to speak of yet, this is the first working version of this module.

## Another Graphite module?

Graphite can be painfull to install and many blog posts and gists are
dedicated to that fact. However it appears to have got easier with most
of the components now available in the Python Package repository. All
the other puppet modules I found either lacked support for
Ubuntu/Debian, relied on an undocumented package or did a lot of
wgetting. 

Although I've only tested this module on Ubuntu it should work on other
distros too, maybe with minor tweaks.
