require 'spec_helper'

describe 'graphite::deps', :type => :class do

  [
    'python-ldap',
    'python-cairo',
    'python-django',
    'python-twisted',
    'python-django-tagging',
    'python-simplejson',
    'python-memcache',
    'python-pysqlite2',
    'python-support',
    'python-pip',
    'gunicorn',
  ].each do |pkg|
    it {
      should contain_package(pkg)
    }
  end
end
