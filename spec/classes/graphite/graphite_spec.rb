require 'spec_helper'

describe 'graphite', :type => :class do
  let(:facts) { {:osfamily => 'debian'} }
  it { should contain_package('whisper')}
  it { should contain_exec('install-graphite-web')}
  it { should contain_exec('install-carbon')}

  it { should contain_service('carbon') }
  it { should contain_service('httpd') }

end
