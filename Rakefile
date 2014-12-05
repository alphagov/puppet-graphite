require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
PuppetLint.configuration.fail_on_warnings = true

# Forsake support for Puppet 2.6.2 for the benefit of cleaner code.
# http://puppet-lint.com/checks/class_parameter_defaults/
PuppetLint.configuration.send('disable_class_parameter_defaults')
# http://puppet-lint.com/checks/class_inherits_from_params_class/
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_80chars')

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]
PuppetLint.configuration.ignore_paths = exclude_paths

desc "Run beaker tests against all OS types"
task :acceptance => [
   'acceptance:ubuntu1204',
   'acceptance:centos64',
]
namespace :acceptance do
   desc "Run beaker tests against Ubuntu 12.04 x86_64"
   RSpec::Core::RakeTask.new(:ubuntu1204) do |t|
       puts "Running acceptance tests for Ubuntu"
       ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'
       ENV['BEAKER_set'] = 'ubuntu-1204-x64'
       t.pattern = 'spec/acceptance'
   end
   desc "Run beaker tests against CentOS 6.4 x86_64"
   RSpec::Core::RakeTask.new(:centos64) do |t|
       puts "Running acceptance tests for CentOS"
       ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'
       ENV['BEAKER_set'] = 'centos-64-x64'
       t.pattern = 'spec/acceptance'
   end
end

desc "Run syntax, lint, and spec tests."
task :test => [
  :syntax,
  :lint,
  :spec,
]
