require 'spec_helper'

describe 'graphite', :type => :class do
  let(:facts) { {:osfamily => 'debian'} }
  it { should create_class('graphite::config')}
  it { should create_class('graphite::install')}
  it { should create_class('graphite::service')}

  it { should contain_package('whisper')}
  it { should contain_exec('install-graphite-web')}
  it { should contain_exec('install-carbon')}

  it { should contain_service('carbon') }
  it { should contain_service('httpd') }

  it { should contain_apache__vhost('graphite').with_port(80) }

  context 'with host' do
    let(:params) { {'port' => 9000} }
    it { should contain_apache__vhost('graphite').with_port(9000) }
  end

  context 'with admin password' do
    let(:params) { {'admin_password' => 'should be a hash' }}
    it { should contain_file('/opt/graphite/webapp/graphite/initial_data.json').with_content(/should be a hash/) }
  end

end
